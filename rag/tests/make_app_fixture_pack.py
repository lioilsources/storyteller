"""Builds app/test/fixtures/mini.CZ.cs.db and mini.core.cs.db — tiny real
packs (real e5 vectors) for the app's RagStore test. Re-run after a pack schema change:

    cd rag && .venv/bin/python tests/make_app_fixture_pack.py
"""

from pathlib import Path

from rag.build_pack import build
from rag.embed import Embedder
from rag.extract import to_motifs
from rag.io import append_jsonl
from rag.schemas import CreatureOut, Hint, MotifExtraction, ScenePrompt, TaleRecord, Transition, Verbalization

OUT = Path(__file__).resolve().parents[2] / "app/test/fixtures/mini.CZ.cs.db"
tmp = OUT.parent / "_mini_src"
tmp.mkdir(exist_ok=True)

ex = MotifExtraction(country_code="CZ", characters=["a clever fox who helps the youngest son"], tasks=["fetch water from a guarded well"], problems=["a dragon blocks the only road"], endings=["the son comes home rich and kind"], tags=["well", "forest", "magic"], environments=["forest"], creatures=[CreatureOut(name_en="Fox", environment="forest")])
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
append_jsonl(tmp / "scenes.jsonl", [
    ScenePrompt(id="s-well", motif_id=by["task"].id, environment_id="forest", phase="task", text_en="Wide shot: {character_refs} at an old stone well guarded by a sleepy dragon, dusk."),
])
append_jsonl(tmp / "trans.jsonl", [
    Transition(from_type="character", to_type="task", tags=["sea"], lang="cs", text="A tak se vypravil k moři…"),
    Transition(from_type="character", to_type="task", tags=["forest"], lang="cs", text="A tak se vydal do lesa…"),
])
from PIL import Image  # noqa: E402

imgs = tmp / "imgs"
imgs.mkdir(exist_ok=True)
Image.new("RGB", (1024, 1024), (70, 130, 180)).save(imgs / f"{by['task'].id}.jpg")  # the task gets a card, the problem doesn't
simgs = tmp / "simgs"
simgs.mkdir(exist_ok=True)
Image.new("RGB", (1024, 1024), (40, 90, 60)).save(simgs / "s-well.jpg")
e = Embedder()
counts = build(OUT, "cs", country="CZ", tales_path=tmp / "tales.jsonl", verbalizations_path=tmp / "verb.jsonl", hints_path=tmp / "hints.jsonl",
               transitions_path=None, scene_prompts_path=tmp / "scenes.jsonl", embed=e.passages, embed_model=e.model_name, embed_ver=e.version,
               images_dir=imgs, scene_images_dir=simgs)
import json  # noqa: E402

cat = tmp / "catalog.json"
cat.write_text(json.dumps({
    "music": {"moods": {"calm": "", "tense": ""}, "environments": {"forest": {"cs": "Les", "prompt": "p"}}},
    "sfx": {"creatures": {"fox": {"cs": "Liška", "prompt": "p", "match": ["fox"]}, "wolf": {"cs": "Vlk", "prompt": "p", "match": ["wolf"]}},
            "actions": {"magic": {"cs": "Kouzlo", "prompt": "p", "match": ["magic"]}, "waves": {"cs": "Vlny", "prompt": "p", "match": ["sea"]}}},
}), encoding="utf-8")
snd = tmp / "snd"
snd.mkdir(exist_ok=True)
for sid in ("music-forest-calm", "music-forest-tense", "creature-fox", "creature-wolf", "action-magic", "action-waves"):
    (snd / f"{sid}.m4a").write_bytes(b"fake-m4a:" + sid.encode())
core = build(OUT.with_name("mini.core.cs.db"), "cs", country=None, tales_path=tmp / "tales.jsonl", verbalizations_path=None, hints_path=None,
             transitions_path=tmp / "trans.jsonl", scene_prompts_path=None, embed=e.passages, embed_model=e.model_name, embed_ver=e.version,
             sounds_dir=snd, audio_catalog=cat)
cat.unlink()
print(core)
for d in (imgs, simgs, snd):
    for f in d.iterdir():
        f.unlink()
    d.rmdir()
for f in tmp.iterdir():
    f.unlink()
tmp.rmdir()
print(OUT, counts)
