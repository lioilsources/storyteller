"""Builds a tiny country pack + core pack from fixtures with a fake
384-d embedder and runs the RAG_PLAN §3 hint query through sqlite-vec."""

import hashlib
import math
import sqlite3
from pathlib import Path

from rag.build_pack import build, nearest_hints, open_pack
from rag.embed import DIM, cosine, dequantize_int8, quantize_int8
from rag.io import append_jsonl
from rag.schemas import Hint, Motif, MotifExtraction, ScenePrompt, TaleRecord, Transition, Verbalization


def fake_embed(texts: list[str]) -> list[list[float]]:
    """Deterministic pseudo-embeddings: same text → same vector; texts
    sharing a keyword land near each other (so retrieval is testable)."""
    out = []
    for t in texts:
        v = [0.0] * DIM
        for word in t.lower().split():
            h = hashlib.sha256(word.encode()).digest()
            for i in range(0, DIM, 8):
                v[i + (h[i // 8 % 32] % 8)] += (h[(i // 8 + 1) % 32] - 128) / 128.0
        n = math.sqrt(sum(x * x for x in v)) or 1.0
        out.append([x / n for x in v])
    return out


def test_int8_roundtrip_preserves_cosine():
    a, b = fake_embed(["fox forest night", "fox forest day"])
    q = dequantize_int8(quantize_int8(a))
    assert abs(cosine(a, q) - 1.0) < 1e-2
    assert abs(cosine(a, b) - cosine(q, dequantize_int8(quantize_int8(b)))) < 2e-2
    assert len(quantize_int8(a)) == DIM


def _fixtures(d: Path):
    ex = MotifExtraction(country_code="DE", endings=["the fox wins"], tags=["forest", "fox"], environments=["forest"])
    motifs = [
        Motif(id="m-char", type="character", text_en="a clever fox", tags=["forest", "fox"], country_code="DE", source_ref="t1", environments=["forest"]),
        Motif(id="m-task", type="task", text_en="find the golden bird", tags=["forest", "bird"], country_code="DE", source_ref="t1", environments=["forest"]),
        Motif(id="m-end", type="ending", text_en="the fox wins", tags=["fox"], country_code="DE", source_ref="t1"),
        Motif(id="m-fr", type="character", text_en="a french cat", tags=["cat"], country_code="FR", source_ref="t2"),
    ]
    append_jsonl(d / "tales.jsonl", [TaleRecord(source_ref="t1", title="T1", extraction=ex, motifs=motifs)])
    append_jsonl(d / "verb.jsonl", [
        Verbalization(motif_id="m-char", lang="cs", age_band="3-6", tone="neutral", length="title", text="Chytrá liška"),
        Verbalization(motif_id="m-fr", lang="cs", age_band="3-6", tone="neutral", length="title", text="Kočka"),
    ])
    append_jsonl(d / "hints.jsonl", [
        Hint(id="h1", motif_id="m-char", phase="problem", environment_id=None, lang="cs", text="…a z houští se ozvalo…", situation_en="the fox hears a noise in the forest bushes"),
        Hint(id="h2", motif_id="m-char", phase="intro", environment_id=None, lang="cs", text="…jak asi liška vypadala?", situation_en="the fox is being introduced at the edge of the forest"),
        Hint(id="h3", motif_id=None, phase="problem", environment_id="forest", lang="cs", text="…co to bylo za zvuk?", situation_en="generic forest problem moment, a sudden sound"),
        Hint(id="h4", motif_id="m-fr", phase="problem", environment_id=None, lang="cs", text="…kočka se zastavila…", situation_en="the cat stops on the road"),
    ])
    append_jsonl(d / "trans.jsonl", [Transition(from_type="character", to_type="task", tags=["forest"], lang="cs", text="Ale dřív, než se vydala na cestu,…")])
    append_jsonl(d / "scenes.jsonl", [ScenePrompt(id="s1", motif_id="m-char", environment_id="forest", phase="intro", text_en="wide shot, {character_refs} at the edge of a forest at dawn")])


def test_country_and_core_packs(tmp_path: Path):
    _fixtures(tmp_path)
    common = dict(tales_path=tmp_path / "tales.jsonl", verbalizations_path=tmp_path / "verb.jsonl", hints_path=tmp_path / "hints.jsonl",
                  transitions_path=tmp_path / "trans.jsonl", scene_prompts_path=tmp_path / "scenes.jsonl", embed=fake_embed, embed_model="fake", embed_ver="1")

    de = build(tmp_path / "country.DE.cs.db", "cs", country="DE", **common)
    assert de["motifs"] == 3 and de["verbalizations"] == 1 and de["scene_prompts"] == 1
    assert de["hint_bank"] == 2 and de["hint_vec"] == 2 and de["hint_emb"] == 2  # h1, h2 — not the FR one, not the generic one
    assert de["compat"] >= 1  # char↔task share 'forest'

    core = build(tmp_path / "core.cs.db", "cs", country=None, **common)
    assert "motifs" not in core and core["hint_bank"] == 1 and core["transitions"] == 1 and core["outline_templates"] == 2

    conn = open_pack(tmp_path / "country.DE.cs.db")
    meta = conn.execute("SELECT pack_id, embed_model, embed_dim FROM meta").fetchone()
    assert meta == ("country.DE.cs", "fake", DIM)

    # RAG_PLAN §3: transcript window → nearest hint at this phase for the outline's motifs
    (q,) = fake_embed(["the fox hears a noise in the forest bushes"])
    res = nearest_hints(conn, q, phase="problem", motif_ids=["m-char"], k=4)
    assert res and res[0][0] == "h1" and res[0][2] > 0.9
    # phase filter: the intro hint never comes back for a problem query
    assert all(r[0] != "h2" for r in res)
    conn.close()


def test_pack_without_embedder_is_marked(tmp_path: Path):
    _fixtures(tmp_path)
    build(tmp_path / "p.db", "cs", country="DE", tales_path=tmp_path / "tales.jsonl", verbalizations_path=None, hints_path=tmp_path / "hints.jsonl",
          transitions_path=None, scene_prompts_path=None, embed=None)
    conn = sqlite3.connect(tmp_path / "p.db")
    assert conn.execute("SELECT embed_model, embed_dim FROM meta").fetchone() == ("", 0)
    assert conn.execute("SELECT count(*) FROM hint_bank").fetchone()[0] == 2
