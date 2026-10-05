"""Builds app/test/fixtures/scenes-cz-v1.zip — a real rag.pack_builder
scenes pack (`scenes.CZ.cs.free`) for the app's PackRepository/RagStore and
narration tests. Two real Czech scene renders from rag/data, plus a scene
for each of mini.CZ.cs.db's task and problem motifs: the task one competes
with the bundled fixture's own s-well (the bundled pack must win), the
problem one exists only here. Re-run after a scenes-pack format change:

    cd rag && .venv/bin/python tests/make_app_fixture_scenes.py
"""

import json
import shutil
import sqlite3
import tempfile
from pathlib import Path

from PIL import Image

import rag.pack_builder as pb
from rag.io import DATA_DIR, append_jsonl, read_jsonl
from rag.schemas import Motif, MotifExtraction, ScenePrompt, TaleRecord

APP = Path(__file__).resolve().parents[2] / "app/test/fixtures"
OUT = APP / "scenes-cz-v1.zip"


def main() -> None:
    # a function: build_scenes encodes in a process pool, and macOS spawn
    # re-imports this file in every worker
    mini = sqlite3.connect(APP / "mini.CZ.cs.db")
    by = dict(mini.execute("SELECT type, id FROM motifs WHERE type IN ('task', 'problem')").fetchall())
    mini.close()

    real = []
    for s in read_jsonl(DATA_DIR / "scene_prompts.jsonl", ScenePrompt):
        if (DATA_DIR / "scene_images" / f"{s.id}.jpg").exists():
            real.append(s)
        if len(real) == 2:
            break

    with tempfile.TemporaryDirectory() as tmp:
        t = Path(tmp)
        imgs = t / "scn"
        imgs.mkdir()
        for s in real:
            shutil.copy(DATA_DIR / "scene_images" / f"{s.id}.jpg", imgs / f"{s.id}.jpg")
        Image.new("RGB", (1024, 1024), (200, 60, 40)).save(imgs / "s-well-all.jpg")
        Image.new("RGB", (1024, 1024), (90, 40, 120)).save(imgs / "s-dragon-all.jpg")
        prompts = [*real,
                   ScenePrompt(id="s-well-all", motif_id=by["task"], environment_id="forest", phase="task", text_en="x"),
                   ScenePrompt(id="s-dragon-all", motif_id=by["problem"], environment_id=None, phase="problem", text_en="x")]
        append_jsonl(t / "scenes.jsonl", prompts)
        ms = [Motif(id=mid, type="task", text_en="-", country_code="CZ", source_ref="fixture") for mid in {p.motif_id for p in prompts}]
        append_jsonl(t / "tales.jsonl", [TaleRecord(source_ref="fixture", title="fixture", extraction=MotifExtraction(), motifs=ms)])
        entry = pb.build_scenes("CZ", "cs", {}, t / "dist", tales_path=t / "tales.jsonl", scene_prompts_path=t / "scenes.jsonl", scene_images_dir=imgs)
        shutil.copy(t / "dist/free-v1" / entry["file"], OUT)
    print(OUT, json.dumps({k: entry[k] for k in ("size", "sha256", "images")}), [s.id for s in real], by)


if __name__ == "__main__":
    main()
