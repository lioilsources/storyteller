import json
from pathlib import Path

from rag.hints import plan
from rag.io import append_jsonl
from rag.scene_prompts import run as scene_run
from rag.schemas import Motif, MotifExtraction, TaleRecord
from rag.sounds import assign, cues, discover, load_catalog
from rag.sources import OriginalResolver


class FakeLLM:
    """Odpoví podle uživatelské zprávy; zapamatuje si, na co se kdo ptal."""

    def __init__(self, answer):
        self.answer, self.asked = answer, []

    def batch(self, items, schema):
        self.asked += [u for _, u in items]
        out = []
        for _, u in items:
            try:
                out.append(schema.model_validate(self.answer(u)))
            except Exception as e:  # noqa: BLE001 — stejně jako LLM.batch vrací chybu na místě
                out.append(e)
        return out


def _tale(ref: str) -> TaleRecord:
    ms = [
        Motif(id=f"{ref}-c", type="character", text_en="a clever fox", source_ref=ref),
        Motif(id=f"{ref}-k", type="character", text_en="a king who owns a horse", source_ref=ref),
        Motif(id=f"{ref}-t1", type="task", text_en="cross the sea in a storm", environments=["sea", "sky"], source_ref=ref),
        Motif(id=f"{ref}-t2", type="task", text_en="open the gate", source_ref=ref),
        Motif(id=f"{ref}-p", type="problem", text_en="a curse", source_ref=ref),
        Motif(id=f"{ref}-e", type="ending", text_en="a wedding", source_ref=ref),
    ]
    return TaleRecord(source_ref=ref, title=ref, extraction=MotifExtraction(), motifs=ms)


def test_catalog_sounds_have_labels_and_no_speech():
    c = load_catalog()
    for section in ("creatures", "actions"):
        for key, e in c["sfx"][section].items():
            assert e["cs"] and e["prompt"] and e["match"], key


def test_assign_writes_only_catalog_ids_and_resumes(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a")])
    out = tmp_path / "character_sounds.jsonl"
    llm = FakeLLM(lambda u: {"key": "fox" if "fox" in u else "not-in-catalog"})
    assert assign(tmp_path / "tales.jsonl", out, 0, llm) == (1, 1)  # klíč mimo katalog neprojde schématem
    assert [json.loads(line) for line in out.read_text().splitlines()] == [{"motif_id": "a-c", "sound": "creature-fox"}]
    llm = FakeLLM(lambda u: {"key": "king"})
    assert assign(tmp_path / "tales.jsonl", out, 0, llm) == (1, 0)  # hotová liška se neptá znovu
    assert len(llm.asked) == 1


def test_cues_skip_characters_and_dedupe(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a")])
    out = tmp_path / "sound_cues.jsonl"
    llm = FakeLLM(lambda u: {"cues": ["thunder", "waves", "thunder"], "mood": "tense"})
    assert cues(tmp_path / "tales.jsonl", out, 0, llm) == (4, 0)
    rows = [json.loads(line) for line in out.read_text().splitlines()]
    assert {r["motif_id"] for r in rows} == {"a-t1", "a-t2", "a-p", "a-e"}
    assert rows[0]["cues"] == ["action-thunder", "action-waves"] and rows[0]["mood"] == "tense"


def test_scene_prompts_scope_one_titled_motif_per_type(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a")])
    llm = FakeLLM(lambda u: {"text_en": "{character_refs} stands on the shore at dusk."})
    ok, failed, dropped = scene_run(
        tmp_path / "tales.jsonl", tmp_path / "sp.jsonl", 0, llm,
        types=frozenset({"task", "problem", "ending"}), envs_per_motif=1, per_type=1, titled=frozenset({"a-t2", "a-p", "a-e", "a-c"}),
    )  # fmt: skip
    assert (ok, failed, dropped) == (15, 0, 0)  # 3 typy × 5 fází; a-t1 nemá titulek, postava není scéna
    assert {json.loads(line)["motif_id"] for line in (tmp_path / "sp.jsonl").read_text().splitlines()} == {"a-t2", "a-p", "a-e"}


def test_hints_own_phase_is_one_unit_per_task_and_problem(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a")])
    resolver = OriginalResolver("cs", {}, root=tmp_path)
    jobs = plan(tmp_path / "tales.jsonl", tmp_path / "hints.jsonl", "cs", 0, resolver, generic=False, own_phase=True)
    assert sorted((j.motif.id, j.extra[1]) for j in jobs) == [("a-p", "problem"), ("a-t1", "task"), ("a-t2", "task")]


def test_discover_collects_free_text_for_story_motifs_only(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a")])
    out = tmp_path / "sound_discovery.jsonl"
    llm = FakeLLM(lambda u: {"sounds": ["Heavy  Gate creaking open"]})
    assert discover(tmp_path / "tales.jsonl", out, 0, llm) == (4, 0)
    rows = [json.loads(line) for line in out.read_text().splitlines()]
    assert all(not r["motif_id"].endswith(("-c", "-k")) for r in rows)
    assert rows[0]["sounds"] == ["heavy gate creaking open"]


def test_cues_with_heard_pass_the_found_sounds_to_the_model(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a")])
    (tmp_path / "heard.jsonl").write_text(json.dumps({"motif_id": "a-t2", "sounds": ["heavy gate creaking open"]}) + "\n")
    llm = FakeLLM(lambda u: {"cues": ["gate"], "mood": "calm"})
    cues(tmp_path / "tales.jsonl", tmp_path / "cues.jsonl", 0, llm, heard_path=tmp_path / "heard.jsonl")
    assert sum("Heard: heavy gate creaking open" in u for u in llm.asked) == 1
