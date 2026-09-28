from rag.classify import apply
from rag.extract import to_motifs
from rag.io import append_jsonl, read_jsonl
from rag.schemas import ClassifyRecord, MotifExtraction, TaleClassification, TaleRecord


def test_schema_sent_to_model_requires_every_field():
    # swarm-director skipped every optional field on all 567 tales (2026-09-26).
    for model in (TaleClassification, MotifExtraction):
        schema = model.model_json_schema()
        assert set(schema["required"]) == set(schema["properties"])
    # ...while validation keeps its defaults for older records.
    assert MotifExtraction.model_validate({}).soft is False


def _tale(ref: str) -> TaleRecord:
    ex = MotifExtraction(characters=["a wolf"], endings=["all is well"])
    return TaleRecord(source_ref=ref, title="t", extraction=ex, motifs=to_motifs(ref, ex))


def test_apply_merges_and_keeps_ground_truth_country(tmp_path):
    tales, classes = tmp_path / "tales.jsonl", tmp_path / "classify.jsonl"
    grimm = "gutenberg:grimm:2591:026-little-red-cap"
    slav = "wikisource:erben-slovanske:010-x"
    todo = "wikisource:lang:000-y"
    append_jsonl(tales, [_tale(grimm), _tale(slav), _tale(todo)])
    ids_before = [m.id for r in read_jsonl(tales, TaleRecord) for m in r.motifs]
    append_jsonl(classes, [
        # the model guessing FR for Grimm must not win over KNOWN_COUNTRY
        ClassifyRecord(source_ref=grimm, classification=TaleClassification(atu_code="333 Little Red Riding Hood", country_code="FR", age_min=6, soft=True)),
        ClassifyRecord(source_ref=slav, classification=TaleClassification(country_code="ru", age_min=3, soft=True)),
    ])

    assert apply(tales, classes) == (2, 1, 0)

    got = {r.source_ref: r for r in read_jsonl(tales, TaleRecord)}
    g = got[grimm]
    assert (g.extraction.atu_code, g.extraction.country_code, g.extraction.age_min, g.extraction.soft) == ("ATU 333", "DE", 6, True)
    assert all((m.country_code, m.age_min, m.soft) == ("DE", 6, True) for m in g.motifs)
    assert got[slav].extraction.country_code == "RU"
    assert got[todo].extraction.soft is False  # not classified yet → untouched
    assert [m.id for r in got.values() for m in r.motifs] == ids_before
    assert not (tmp_path / "tales.jsonl.tmp").exists()


def test_contested_tradition_keeps_people_not_country(tmp_path):
    # user decision 2026-09-27: for Tibet store the people, claim no state
    tales, classes = tmp_path / "tales.jsonl", tmp_path / "classify.jsonl"
    ref = "gutenberg:tibet-jewett:66443:000-x"
    append_jsonl(tales, [_tale(ref)])
    append_jsonl(classes, [ClassifyRecord(source_ref=ref, classification=TaleClassification(country_code="CN", people="Chinese", age_min=3, soft=True))])
    apply(tales, classes)
    (rec,) = read_jsonl(tales, TaleRecord)
    assert (rec.extraction.country_code, rec.extraction.people) == ("", "Tibetan")
    assert all((m.country_code, m.people) == ("", "Tibetan") for m in rec.motifs)

