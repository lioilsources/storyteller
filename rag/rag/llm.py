"""Minimal LiteLLM (OpenAI-compatible) client with structured JSON output.

Config from the environment:

    LITELLM_BASE_URL   e.g. http://<spark-host>:4000/v1
    LITELLM_API_KEY    optional
    LITELLM_MODEL      e.g. qwen3-4b  (PLAN §6.1 candidates)

Every call asks for a pydantic schema. We first try OpenAI's
`response_format: json_schema` (vLLM honours it as guided decoding); if
the server rejects that (400), we fall back to `json_object` and lean on
validation + retry. A validation failure is fed back to the model once
as a correction, then the item fails — the caller decides whether that
blocks (extract) or is skipped (verbalize variants).
"""

from __future__ import annotations

import asyncio
import json
import os
import time
from dataclasses import dataclass, field
from typing import Any, TypeVar

import httpx
from pydantic import BaseModel, ValidationError

T = TypeVar("T", bound=BaseModel)


class LLMError(RuntimeError):
    pass


@dataclass
class LLM:
    base_url: str = field(default_factory=lambda: os.environ.get("LITELLM_BASE_URL", ""))
    api_key: str = field(default_factory=lambda: os.environ.get("LITELLM_API_KEY", ""))
    model: str = field(default_factory=lambda: os.environ.get("LITELLM_MODEL", ""))
    temperature: float = 0.4
    max_tokens: int = 1500
    # seconds per request; a shared model under load needs far more than an idle one
    timeout: float = field(default_factory=lambda: float(os.environ.get("LITELLM_TIMEOUT", "120")))
    # parallel requests; lower it on a shared model so other jobs are not starved
    concurrency: int = field(default_factory=lambda: int(os.environ.get("LITELLM_CONCURRENCY", "8")))
    max_attempts: int = 3
    transport: httpx.BaseTransport | None = None  # tests inject a MockTransport
    _use_json_schema: bool = True

    def __post_init__(self) -> None:
        if not self.base_url:
            raise LLMError("LITELLM_BASE_URL is not set — LiteLLM's OpenAI-compatible base, e.g. http://spark.local:4000/v1")
        if not self.model:
            raise LLMError("LITELLM_MODEL is not set — see STORYTELLER_PLAN.md §6.1")
        self.base_url = self.base_url.rstrip("/")

    # -- public ---------------------------------------------------------

    def chat(self, system: str, user: str, schema: type[T]) -> T:
        """Blocking single call."""
        with httpx.Client(timeout=self.timeout, transport=self.transport) as client:
            return self._call(client, system, user, schema)

    def batch(self, items: list[tuple[str, str]], schema: type[T]) -> list[T | Exception]:
        """Run many (system, user) prompts concurrently; failures come back as exceptions in place."""
        return asyncio.run(self._batch(items, schema))

    # -- internals ------------------------------------------------------

    def _headers(self) -> dict[str, str]:
        h = {"Content-Type": "application/json"}
        if self.api_key:
            h["Authorization"] = f"Bearer {self.api_key}"
        return h

    def _body(self, messages: list[dict[str, str]], schema: type[BaseModel]) -> dict[str, Any]:
        body: dict[str, Any] = {
            "model": self.model,
            "messages": messages,
            "temperature": self.temperature,
            "max_tokens": self.max_tokens,
        }
        if self._use_json_schema:
            body["response_format"] = {
                "type": "json_schema",
                "json_schema": {"name": schema.__name__, "schema": schema.model_json_schema(), "strict": False},
            }
        else:
            body["response_format"] = {"type": "json_object"}
        return body

    def _call(self, client: httpx.Client, system: str, user: str, schema: type[T]) -> T:
        messages = [{"role": "system", "content": system}, {"role": "user", "content": user}]
        last: Exception | None = None
        for attempt in range(self.max_attempts):
            try:
                content = self._post(client, messages, schema)
                return schema.model_validate_json(_strip_fences(content))
            except ValidationError as e:
                last = e
                # Feed the error back once; the model usually fixes shape on the second try.
                messages = messages[:2] + [
                    {"role": "assistant", "content": content},
                    {"role": "user", "content": f"That JSON did not match the schema:\n{e}\nReturn only corrected JSON."},
                ]
            except httpx.HTTPStatusError as e:
                if e.response.status_code == 400 and self._use_json_schema:
                    # Server doesn't do json_schema guided decoding; degrade for the rest of the run.
                    self._use_json_schema = False
                    continue
                last = e
                if e.response.status_code in (429, 500, 502, 503, 504):
                    time.sleep(1.5 * (attempt + 1))
                    continue
                raise LLMError(f"llm: {e.response.status_code}: {e.response.text[:300]}") from e
            except httpx.TransportError as e:
                last = e
                time.sleep(1.5 * (attempt + 1))
        raise LLMError(f"llm: gave up after {self.max_attempts} attempts: {last}")

    def _post(self, client: httpx.Client, messages: list[dict[str, str]], schema: type[BaseModel]) -> str:
        r = client.post(f"{self.base_url}/chat/completions", headers=self._headers(), json=self._body(messages, schema))
        r.raise_for_status()
        data = r.json()
        if "error" in data:
            raise LLMError(f"llm: api error: {data['error']}")
        try:
            return data["choices"][0]["message"]["content"]
        except (KeyError, IndexError) as e:
            raise LLMError(f"llm: no choices in response: {json.dumps(data)[:300]}") from e

    async def _batch(self, items: list[tuple[str, str]], schema: type[T]) -> list[T | Exception]:
        sem = asyncio.Semaphore(self.concurrency)

        async def one(system: str, user: str) -> T | Exception:
            async with sem:
                try:
                    return await asyncio.to_thread(self.chat, system, user, schema)
                except Exception as e:  # noqa: BLE001 — surfaced to the caller per item
                    return e

        return await asyncio.gather(*(one(s, u) for s, u in items))


def _strip_fences(s: str) -> str:
    """Small models sometimes wrap JSON in ```json fences despite instructions."""
    s = s.strip()
    if s.startswith("```"):
        s = s.split("\n", 1)[1] if "\n" in s else s[3:]
        if s.rstrip().endswith("```"):
            s = s.rstrip()[:-3]
    return s.strip()
