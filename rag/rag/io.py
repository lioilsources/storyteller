"""JSONL in/out + resumable stage runner shared by every pipeline stage.

Each stage writes one JSONL file and can be re-run: records whose `key`
is already present are skipped, so a crashed 3-day verbalize run
continues where it stopped (RAG_PLAN §7 estimates assume this).
"""

from __future__ import annotations

import hashlib
import json
import sys
from collections.abc import Callable, Iterable, Iterator
from pathlib import Path
from typing import TypeVar

from pydantic import BaseModel

T = TypeVar("T", bound=BaseModel)

DATA_DIR = Path(__file__).resolve().parent.parent / "data"


def stable_id(*parts: str, n: int = 16) -> str:
    """Deterministic id from its identifying parts — same input, same id,
    across runs and machines. Mirrors the spirit of internal/contentkey."""
    h = hashlib.sha256("\x1f".join(parts).encode("utf-8")).hexdigest()
    return h[:n]


def read_jsonl(path: Path, model: type[T]) -> Iterator[T]:
    if not path.exists():
        return
    with path.open(encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                yield model.model_validate_json(line)


def append_jsonl(path: Path, records: Iterable[BaseModel]) -> int:
    path.parent.mkdir(parents=True, exist_ok=True)
    n = 0
    with path.open("a", encoding="utf-8") as f:
        for r in records:
            f.write(r.model_dump_json(exclude_none=False))
            f.write("\n")
            n += 1
    return n


def done_keys(path: Path, model: type[T], key: Callable[[T], str]) -> set[str]:
    return {key(r) for r in read_jsonl(path, model)}


def log(msg: str) -> None:
    print(msg, file=sys.stderr, flush=True)
