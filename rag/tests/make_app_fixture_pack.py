"""Builds app/test/fixtures/mini.CZ.cs.db — a tiny real pack (real e5
vectors) for the app's RagStore test. Re-run after a pack schema change:

    cd rag && .venv/bin/python tests/make_app_fixture_pack.py
"""

from pathlib import Path

from rag.build_pack import build
from rag.embed import Embedder
from rag.extract import to_motifs
from rag.io import append_jsonl
from rag.schemas import Hint, MotifExtraction, TaleRecord, Verbalization

OUT = Path(__file__).resolve().parents[2] / "app/test/fixtures/mini.CZ.cs.db"
tmp = OUT.parent / "_mini_src"
tmp.mkdir(exist_ok=True)

ex = MotifExtraction(country_code="CZ", characters=["a clever fox who helps the youngest son"], tasks=["fetch water from a guarded well"], problems=["a dragon blocks the only road"], endings=["the son comes home rich and kind"])
rec = TaleRecord(source_ref="wikisource:nemcova:000-fixture", title="Fixture", extraction=ex, motifs=to_motifs("wikisource:nemcova:000-fixture", ex))
for m in rec.motifs:
    m.country_code = "CZ"
append_jsonl(tmp / "tales.jsonl", [rec])
by = {m.type: m for m in rec.motifs}
append_jsonl(tmp / "verb.jsonl", [
    Verbalization(motif_id=by["task"].id, lang="cs", age_band="3-6", tone="neutral", length="title", text="Voda ze střežené studny"),
    Verbalization(motif_id=by["task"].id, lang="cs", age_band="3-6", tone="neutral", length="sentence", text="Musí přinést vodu ze studny, kterou někdo hlídá."),
    Verbalization(motif_id=by["problem"].id, lang="cs", age_band="3-6", tone="neutral", length="title", text="Drak na cestě"),
])
append_jsonl(tmp / "hints.jsonl", [
    Hint(id="h-dragon", motif_id=by["problem"].id, phase="problem", environment_id=None, lang="cs", text="A tu se ze skály ozvalo funění…", situation_en="A dragon has just appeared on the road and the hero cannot pass."),
    Hint(id="h-well", motif_id=by["task"].id, phase="task", environment_id=None, lang="cs", text="Kdo asi hlídá tu starou studnu?", situation_en="The hero reaches the old well and sees it is guarded."),
    Hint(id="h-generic", motif_id=None, phase="problem", environment_id="forest", lang="cs", text="V lese se najednou setmělo…", situation_en="Something unexpected happens in the forest."),
])
e = Embedder()
counts = build(OUT, "cs", country="CZ", tales_path=tmp / "tales.jsonl", verbalizations_path=tmp / "verb.jsonl", hints_path=tmp / "hints.jsonl",
               transitions_path=None, scene_prompts_path=None, embed=e.passages, embed_model=e.model_name, embed_ver=e.version)
for f in tmp.iterdir():
    f.unlink()
tmp.rmdir()
print(OUT, counts)
