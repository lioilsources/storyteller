import json

import httpx
import pytest
from pydantic import BaseModel

from rag.extract import to_motifs
from rag.llm import LLM, LLMError, _strip_fences
from rag.schemas import MotifExtraction


def test_extraction_normalises():
    ex = MotifExtraction.model_validate(
        {
            "atu_code": "ATU 550",
            "country_code": " de ",
            "age_min": 4,
            "characters": ["  a clever  fox ", "a clever fox", ""],
            "tags": ["Forest", "forest"],
        }
    )
    assert ex.country_code == "DE"
    assert ex.age_min == 3
    assert ex.characters == ["a clever fox"]
    assert ex.tags == ["Forest"]  # dedupe is case-insensitive, keeps first spelling


def test_bad_country_code_dropped():
    assert MotifExtraction.model_validate({"country_code": "Germany"}).country_code == ""


def test_motif_ids_are_deterministic():
    ex = MotifExtraction(characters=["a fox"], tasks=["find the bird"], endings=["all is well"])
    a = to_motifs("gutenberg:grimm:2591:000-x", ex)
    b = to_motifs("gutenberg:grimm:2591:000-x", ex)
    assert [m.id for m in a] == [m.id for m in b]
    assert len({m.id for m in a}) == 3
    assert {m.type for m in a} == {"character", "task", "ending"}


def test_strip_fences():
    assert _strip_fences('```json\n{"a": 1}\n```') == '{"a": 1}'
    assert _strip_fences('{"a": 1}') == '{"a": 1}'


class Out(BaseModel):
    x: int


def _llm(handler) -> LLM:
    return LLM(base_url="http://test/v1", model="m", transport=httpx.MockTransport(handler), max_attempts=3)


def test_llm_requires_config(monkeypatch):
    monkeypatch.delenv("LITELLM_BASE_URL", raising=False)
    with pytest.raises(LLMError):
        LLM(model="m")


def test_llm_happy_path_uses_json_schema():
    seen = {}

    def handler(req: httpx.Request) -> httpx.Response:
        body = json.loads(req.content)
        seen["rf"] = body["response_format"]["type"]
        return httpx.Response(200, json={"choices": [{"message": {"content": '{"x": 7}'}}]})

    assert _llm(handler).chat("s", "u", Out).x == 7
    assert seen["rf"] == "json_schema"


def test_llm_falls_back_to_json_object_on_400():
    calls = []

    def handler(req: httpx.Request) -> httpx.Response:
        rf = json.loads(req.content)["response_format"]["type"]
        calls.append(rf)
        if rf == "json_schema":
            return httpx.Response(400, json={"error": "unsupported"})
        return httpx.Response(200, json={"choices": [{"message": {"content": '```json\n{"x": 1}\n```'}}]})

    llm = _llm(handler)
    assert llm.chat("s", "u", Out).x == 1
    assert calls == ["json_schema", "json_object"]
    # degraded for the rest of the run
    assert llm.chat("s", "u", Out).x == 1
    assert calls[-1] == "json_object"


def test_llm_feeds_validation_error_back_once():
    n = {"i": 0}

    def handler(req: httpx.Request) -> httpx.Response:
        n["i"] += 1
        msgs = json.loads(req.content)["messages"]
        if n["i"] == 1:
            return httpx.Response(200, json={"choices": [{"message": {"content": '{"x": "not a number"}'}}]})
        assert "did not match the schema" in msgs[-1]["content"]
        return httpx.Response(200, json={"choices": [{"message": {"content": '{"x": 2}'}}]})

    assert _llm(handler).chat("s", "u", Out).x == 2


def test_llm_batch_isolates_failures():
    def handler(req: httpx.Request) -> httpx.Response:
        user = json.loads(req.content)["messages"][1]["content"]
        if user == "bad":
            return httpx.Response(200, json={"choices": [{"message": {"content": "nope"}}]})
        return httpx.Response(200, json={"choices": [{"message": {"content": '{"x": 3}'}}]})

    res = _llm(handler).batch([("s", "ok"), ("s", "bad"), ("s", "ok")], Out)
    assert isinstance(res[0], Out) and isinstance(res[2], Out)
    assert isinstance(res[1], Exception)
