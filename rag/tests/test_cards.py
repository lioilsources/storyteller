from pathlib import Path

from rag.cards import acceptable, select
from rag.io import append_jsonl
from rag.schemas import CardOut, Motif, MotifExtraction, TaleRecord


def _tale(ref: str, cc: str, n: int) -> TaleRecord:
    ms = [Motif(id=f"{ref}-c{i}", type="character", text_en=f"hero {i}", country_code=cc, source_ref=ref) for i in range(n)]
    ms.append(Motif(id=f"{ref}-t", type="task", text_en="a task", country_code=cc, source_ref=ref))
    return TaleRecord(source_ref=ref, title=ref, extraction=MotifExtraction(), motifs=ms)


def test_select_round_robins_tales_and_pins_art(tmp_path: Path):
    append_jsonl(tmp_path / "tales.jsonl", [_tale("a", "GH", 5), _tale("b", "GH", 1), _tale("c", "CZ", 2)])
    (tmp_path / "img").mkdir()
    (tmp_path / "img" / "c-c1.jpg").write_bytes(b"x")
    picks = [m.id for m, _ in select(tmp_path / "tales.jsonl", 2, 1, {"GH"}, tmp_path / "img")]
    assert picks[0] == "c-c1"  # has art → always carded, even outside --countries
    assert set(picks[1:]) == {"a-c0", "b-c0", "a-t"}  # one per tale before a second from the same tale


def test_acceptable_rejects_captions_as_names():
    assert acceptable(CardOut(title="Chytrá liška", sentence="Liška měla v lese nejvíc nápadů."), "character", "cs")
    assert not acceptable(CardOut(title="Přísaha pod svatebním stromem u řeky", sentence="Byla jednou jedna přísaha."), "character", "cs")
    assert not acceptable(CardOut(title="The clever fox", sentence="The fox was the smartest in the forest."), "character", "cs")
    assert not acceptable(CardOut(title="Liška", sentence="Liška šla. Pak se vrátila domů."), "character", "cs")
