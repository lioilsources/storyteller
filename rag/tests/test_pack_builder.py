import json
import zipfile
from pathlib import Path

import pytest

import rag.pack_builder as pb
from rag.io import append_jsonl
from rag.schemas import Motif, MotifExtraction, TaleRecord, Verbalization


def _tale(ref: str, cc: str, n: int) -> TaleRecord:
    ms = [Motif(id=f"{ref}-{i}", type="character", text_en=f"hero {i}", country_code=cc, source_ref=ref) for i in range(n)]
    return TaleRecord(source_ref=ref, title=ref, extraction=MotifExtraction(), motifs=ms)


@pytest.fixture
def data(tmp_path: Path, monkeypatch):
    d = tmp_path / "data"
    d.mkdir()
    monkeypatch.setattr(pb, "DATA_DIR", d)
    # tale t0 shows 1 motif, t1 shows 3, …: readiness ranks t6 first
    tales = [_tale(f"t{i}", "GH", 3) for i in range(7)]
    append_jsonl(d / "tales.jsonl", tales)
    append_jsonl(d / "cards.cs.jsonl", [Verbalization(motif_id=f"t{i}-{j}", lang="cs", age_band="3-6", tone="neutral", length="title", text=f"Jméno {i}{j}") for i in range(7) for j in range(1 + i % 3)])
    return d


def _run(d: Path, dist: Path, state: Path):
    return pb.build_all("cs", None, embed=None, embed_model="", embed_ver="", dist=dist, state_path=state, tales_path=d / "tales.jsonl", images_dir=d / "img", scene_images_dir=d / "scn")


def test_tiers_stable_versions_bump_only_on_change(data: Path, tmp_path: Path):
    dist, state = tmp_path / "dist", tmp_path / "state.json"
    m1 = _run(data, dist, state)
    st = json.loads(state.read_text())["countries"]["GH"]
    assert len(st["free"]) == 5 and len(st["paid"]) == 2
    assert m1["countries"]["gh"]["free"]["file"] == "gh-free-v1.zip"
    assert "url" not in json.dumps(m1["countries"])  # paid URLs are built by the client after entitlement
    z1 = (dist / "free-v1/gh-free-v1.zip").read_bytes()

    m2 = _run(data, dist, state)  # nothing changed
    assert m2 == m1
    assert (dist / "free-v1/gh-free-v1.zip").read_bytes() == z1

    # a new, better tale must not push anything out of free
    append_jsonl(data / "tales.jsonl", [_tale("t9", "GH", 3)])
    append_jsonl(data / "cards.cs.jsonl", [Verbalization(motif_id=f"t9-{j}", lang="cs", age_band="3-6", tone="neutral", length="title", text="X") for j in range(3)])
    m3 = _run(data, dist, state)
    st3 = json.loads(state.read_text())["countries"]["GH"]
    assert st3["free"] == st["free"] and st3["paid"] == st["paid"] + ["t9"]
    assert m3["countries"]["gh"]["free"]["version"] == 1
    assert m3["countries"]["gh"]["paid"]["version"] == 2


def test_zip_carries_pack_json_with_file_hashes(data: Path, tmp_path: Path):
    dist = tmp_path / "dist"
    _run(data, dist, tmp_path / "s.json")
    with zipfile.ZipFile(dist / "pack-gh-v1/gh-lite.zip") as z:
        meta = json.loads(z.read("pack.json"))
        assert meta["tier"] == "lite" and meta["country"] == "GH"
        (name, f), = meta["files"].items()
        import hashlib
        assert hashlib.sha256(z.read(name)).hexdigest() == f["sha256"]


def test_budget_fails_the_build(data: Path, tmp_path: Path, monkeypatch):
    monkeypatch.setattr(pb, "TALE_BUDGET_BYTES", 5)
    with pytest.raises(pb.BudgetError):
        _run(data, tmp_path / "dist", tmp_path / "s.json")
