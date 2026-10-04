"""Originál napřed (rag.sources): jazyk textu pohádky, výběr zdroje,
hledání úryvku, regen a preference v build_packu. Bez sítě a bez modelů."""

import json
from pathlib import Path

import pytest

from rag import cards, hints, verbalize
from rag.build_pack import build
from rag.io import append_jsonl, read_jsonl
from rag.schemas import Hint, Motif, MotifExtraction, TaleRecord, Verbalization
from rag.sources import (
    ORIGINAL_RULE,
    OriginalResolver,
    TaleSource,
    build_index,
    excerpt,
    guess_lang,
    keywords,
    needs_work,
    prefer_original,
    sources_by_key,
)

CS_TEXT = (
    "Byl jeden chudý mlynář a měl tři syny.\n\n"
    + "Šli lesem a nic se nedělo, jen ptáci zpívali. " * 40
    + "\n\nTu potkali starou lišku, která mluvila lidskou řečí a wolala na ně z houští.\n\n"
    + "Šli dál a dál přes hory a doly. " * 40
    + "\n\nNakonec se nejmladší oženil s princeznou a byla veliká svatba.\n"
)

EN_TEXT = (
    "Once upon a time there was a poor miller who had three sons.\n\n"
    + "They walked along the road and nothing happened at all. " * 40
    + "\n\nThen a clever fox came out of the bushes and spoke to the youngest.\n\n"
    + "They went on over hills and valleys for many days. " * 40
    + "\n\nAt last the youngest married the princess and there was a great wedding.\n"
)


def _corpus(tmp_path: Path) -> tuple[Path, Path]:
    raw = tmp_path / "corpus" / "data" / "raw"
    g = raw / "grimm" / "2591-tales"
    g.mkdir(parents=True)
    (g / "000-the-fox.txt").write_text(EN_TEXT, encoding="utf-8")
    (g / "index.json").write_text(json.dumps([{"file": "000-the-fox.txt", "idx": 0, "title": "THE FOX"}]), encoding="utf-8")
    w = raw / "nemcova" / "tales"
    w.mkdir(parents=True)
    (w / "000-liska.txt").write_text(CS_TEXT, encoding="utf-8")
    (w / "index.json").write_text(json.dumps([{"file": "000-liska.txt", "idx": 0, "title": "O lišce", "url": "https://cs.wikisource.org/wiki/X"}]), encoding="utf-8")
    (raw / "nemcova" / "meta.json").write_text(json.dumps({"collection": "nemcova", "lang": "cs"}), encoding="utf-8")

    tales = tmp_path / "tales.jsonl"
    recs = []
    for ref, title in (("gutenberg:grimm:2591:000-the-fox", "THE FOX"), ("wikisource:nemcova:000-liska", "O lišce")):
        ms = [
            Motif(id=f"{ref}|c", type="character", text_en="a clever talking fox who helps the youngest son", tags=["fox", "forest"], source_ref=ref, country_code="DE"),
            Motif(id=f"{ref}|e", type="ending", text_en="the youngest son marries the princess", tags=["wedding"], source_ref=ref, country_code="DE"),
        ]
        recs.append(TaleRecord(source_ref=ref, title=title, extraction=MotifExtraction(endings=["the youngest son marries the princess"]), motifs=ms))
    append_jsonl(tales, recs)
    return raw, tales


@pytest.fixture
def corpus(tmp_path: Path):
    raw, tales = _corpus(tmp_path)
    index = {r.source_ref: r for r in build_index(raw, tales)}
    return tmp_path, tales, index


def _motif(tales: Path, mid: str) -> Motif:
    return next(m for r in read_jsonl(tales, TaleRecord) for m in r.motifs if m.id == mid)


# -- index ------------------------------------------------------------


def test_index_reads_language_from_fetcher_metadata(corpus):
    _, _, index = corpus
    g = index["gutenberg:grimm:2591:000-the-fox"]
    w = index["wikisource:nemcova:000-liska"]
    assert (g.source_lang, g.translated_from, g.lang_check) == ("en", "de", "")
    assert (w.source_lang, w.url, w.lang_check) == ("cs", "https://cs.wikisource.org/wiki/X", "")
    assert w.path.endswith("nemcova/tales/000-liska.txt") and w.chars == len(CS_TEXT)


def test_index_flags_missing_text(tmp_path: Path):
    raw, tales = _corpus(tmp_path)
    (raw / "nemcova" / "tales" / "000-liska.txt").unlink()
    (raw / "nemcova" / "tales" / "index.json").write_text("[]", encoding="utf-8")
    w = {r.source_ref: r for r in build_index(raw, tales)}["wikisource:nemcova:000-liska"]
    assert w.source_lang == "cs" and w.path == "" and w.lang_check


def test_guess_lang():
    assert guess_lang(EN_TEXT) == "en"
    assert guess_lang(CS_TEXT) == "cs"


# -- výběr zdroje -----------------------------------------------------


def test_source_follows_the_language_of_the_text_we_have(corpus):
    root, tales, index = corpus
    fox_en, fox_cs = _motif(tales, "gutenberg:grimm:2591:000-the-fox|c"), _motif(tales, "wikisource:nemcova:000-liska|c")
    cs, en, de = (OriginalResolver(lang, index, root=root) for lang in ("cs", "en", "de"))
    assert (cs.source_for(fox_cs), cs.source_for(fox_en)) == ("original", "text_en")
    assert (en.source_for(fox_cs), en.source_for(fox_en)) == ("text_en", "original")
    # Grimm je německý, ale německý text v korpusu není → z text_en, ne přes angličtinu
    assert (de.source_for(fox_cs), de.source_for(fox_en)) == ("text_en", "text_en")
    assert de.block(fox_en) == "" and de.system("S", fox_en, "German") == "S"


def test_original_block_and_rule(corpus):
    root, tales, index = corpus
    m = _motif(tales, "wikisource:nemcova:000-liska|c")
    r = OriginalResolver("cs", index, root=root, budget=600)
    block = r.block(m)
    assert "Tale: O lišce" in block and "lišku" in block
    assert r.system("S", m, "Czech").endswith(ORIGINAL_RULE.format(lang_name="Czech"))


def test_missing_original_fails_loudly(corpus):
    root, tales, index = corpus
    m = _motif(tales, "wikisource:nemcova:000-liska|c")
    (root / index[m.source_ref].path).unlink()  # absolutní cesta (tmp mimo repo) přebije root
    r = OriginalResolver("cs", index, root=root)
    assert r.missing([m]) == [m.source_ref]
    with pytest.raises(FileNotFoundError):
        r.block(m)


# -- úryvek -----------------------------------------------------------


def test_excerpt_short_text_is_whole_but_without_the_ending_for_non_endings():
    text = "Začátek.\n\n" + "Prostředek. " * 5 + "\n\n" + "Konec, svatba."
    assert "svatba" not in excerpt(text, mtype="character", motif_text="a fox", lang="cs")
    assert "svatba" in excerpt(text, mtype="ending", motif_text="a wedding", lang="cs")


def test_excerpt_finds_the_scene_by_english_keywords():
    ex = excerpt(EN_TEXT, mtype="character", motif_text="a clever talking fox", lang="en", budget=900)
    assert "clever fox came out of the bushes" in ex
    assert ex.startswith("Once upon a time")  # úvod se jmény jde vždy
    assert "[…]" in ex
    assert "wedding" not in ex


def test_excerpt_finds_the_scene_in_czech_via_cues_and_old_spelling():
    assert "lis" in keywords("a clever talking fox", ["forest"], "cs")
    ex = excerpt(CS_TEXT, mtype="character", motif_text="a clever talking fox", tags=["fox"], lang="cs", budget=900)
    assert "starou lišku" in ex
    assert "svatba" not in ex


def test_excerpt_ending_motif_reaches_the_end():
    ex = excerpt(CS_TEXT, mtype="ending", motif_text="the youngest son marries the princess at a wedding", lang="cs", budget=900)
    assert "svatba" in ex


def test_excerpt_respects_budget():
    assert len(excerpt(EN_TEXT, mtype="task", motif_text="walk the road", lang="en", budget=700)) <= 760


# -- resume / regen / preference --------------------------------------


def test_needs_work_normal_and_regen():
    have = {"a": {"text_en"}, "b": {"text_en", "original"}}
    assert not needs_work("a", have, "original", regen=False)  # běžný běh: už hotové
    assert needs_work("x", have, "text_en", regen=False)
    assert needs_work("a", have, "original", regen=True)  # regen: text_en → z originálu
    assert not needs_work("b", have, "original", regen=True)  # už přegenerované
    assert not needs_work("x", have, "original", regen=True)  # regen nic nového nepřidává
    assert not needs_work("a", have, "text_en", regen=True)  # bez originálu není co přegenerovat


def test_old_rows_without_source_read_as_text_en(tmp_path: Path):
    p = tmp_path / "v.jsonl"
    p.write_text('{"motif_id":"m","lang":"cs","age_band":"3-6","tone":"neutral","length":"title","text":"Liška"}\n', encoding="utf-8")
    assert sources_by_key(p, Verbalization, lambda v: v.motif_id) == {"m": {"text_en"}}


def test_prefer_original_drops_text_en_rows_of_regenerated_keys():
    rows = [
        Verbalization(motif_id="m", lang="cs", age_band="3-6", tone="neutral", length="title", text="Lis"),
        Verbalization(motif_id="n", lang="cs", age_band="3-6", tone="neutral", length="title", text="Kovář"),
        Verbalization(motif_id="m", lang="cs", age_band="3-6", tone="neutral", length="title", text="Liška Bystrouška", source="original"),
    ]
    assert [v.text for v in prefer_original(rows, lambda v: v.motif_id)] == ["Kovář", "Liška Bystrouška"]


def test_verbalize_plan_regen_only_touches_original_tales(corpus):
    root, tales, index = corpus
    out = root / "verbalizations.cs.jsonl"
    r = OriginalResolver("cs", index, root=root)
    jobs = verbalize.plan(tales, out, "cs", 0, r)
    by = {j.key: j for j in jobs}
    assert by["wikisource:nemcova:000-liska|c"].source == "original"
    assert "Original text excerpt" in by["wikisource:nemcova:000-liska|c"].user
    assert by["gutenberg:grimm:2591:000-the-fox|c"].source == "text_en"
    assert "Original text excerpt" not in by["gutenberg:grimm:2591:000-the-fox|c"].user

    # staré řádky z text_en pro obě pohádky
    append_jsonl(out, [Verbalization(motif_id=k, lang="cs", age_band="3-6", tone="neutral", length="title", text="x") for k in by])
    assert verbalize.plan(tales, out, "cs", 0, r) == []
    regen = verbalize.plan(tales, out, "cs", 0, r, regen=True)
    assert {j.key for j in regen} == {"wikisource:nemcova:000-liska|c", "wikisource:nemcova:000-liska|e"}
    assert all(j.source == "original" for j in regen)


def test_hints_plan_regen_skips_generic_and_endings(corpus):
    root, tales, index = corpus
    out = root / "hints.cs.jsonl"
    r = OriginalResolver("cs", index, root=root)
    jobs = hints.plan(tales, out, "cs", 0, r)
    assert sum(j.motif is None for j in jobs) == len(hints.ENVIRONMENTS) * 5
    rows = [Hint(id=str(i), motif_id=j.motif.id if j.motif else None, phase=j.extra[1], environment_id=j.extra[0], lang="cs", text="…", situation_en="s") for i, j in enumerate(jobs)]
    append_jsonl(out, rows)
    regen = hints.plan(tales, out, "cs", 0, r, regen=True)
    assert {j.motif.id for j in regen} == {"wikisource:nemcova:000-liska|c"}  # ending motif nemá nápovědy
    assert len(regen) == 5 and all(j.source == "original" for j in regen)


def test_cards_plan_regen_and_same_motifs(corpus):
    root, tales, index = corpus
    out = root / "cards.en.jsonl"
    r = OriginalResolver("en", index, root=root)
    picks = cards.same_motifs(tales, frozenset({"gutenberg:grimm:2591:000-the-fox|c", "wikisource:nemcova:000-liska|c"}))
    jobs = cards.plan(tales, out, "en", picks, r)
    assert {j.key: j.source for j in jobs} == {"gutenberg:grimm:2591:000-the-fox|c": "original", "wikisource:nemcova:000-liska|c": "text_en"}
    append_jsonl(out, [Verbalization(motif_id=j.key, lang="en", age_band="3-6", tone="neutral", length="title", text="x") for j in jobs])
    assert [j.key for j in cards.plan(tales, out, "en", [], r, regen=True)] == ["gutenberg:grimm:2591:000-the-fox|c"]


def test_build_pack_prefers_original_rows(tmp_path: Path):
    ref = "wikisource:nemcova:000-liska"
    m = Motif(id="m1", type="character", text_en="a fox", country_code="CZ", source_ref=ref)
    append_jsonl(tmp_path / "tales.jsonl", [TaleRecord(source_ref=ref, title="t", extraction=MotifExtraction(), motifs=[m])])
    append_jsonl(tmp_path / "v.jsonl", [
        Verbalization(motif_id="m1", lang="cs", age_band="3-6", tone="neutral", length="title", text="Lis"),
        Verbalization(motif_id="m1", lang="cs", age_band="3-6", tone="neutral", length="title", text="Liška Ryška", source="original"),
    ])
    append_jsonl(tmp_path / "h.jsonl", [
        Hint(id="h1", motif_id="m1", phase="intro", environment_id=None, lang="cs", text="Stará hint…", situation_en="s"),
        Hint(id="h2", motif_id="m1", phase="intro", environment_id=None, lang="cs", text="Nová…", situation_en="s", source="original"),
        Hint(id="h2", motif_id="m1", phase="intro", environment_id=None, lang="cs", text="Nová…", situation_en="s", source="original"),
        Hint(id="h3", motif_id="m1", phase="task", environment_id=None, lang="cs", text="Jen stará…", situation_en="s"),
    ])
    out = tmp_path / "p.db"
    counts = build(out, "cs", country="CZ", tales_path=tmp_path / "tales.jsonl", verbalizations_path=tmp_path / "v.jsonl",
                   hints_path=tmp_path / "h.jsonl", transitions_path=None, scene_prompts_path=None, embed=None)
    import sqlite3

    conn = sqlite3.connect(out)
    assert [r[0] for r in conn.execute("SELECT text FROM verbalizations")] == ["Liška Ryška"]
    assert sorted(r[0] for r in conn.execute("SELECT id FROM hint_bank")) == ["h2", "h3"]
    assert counts["hint_bank"] == 2


def test_index_row_roundtrip():
    r = TaleSource(source_ref="a:b:c", collection="b", title="t", source="gutenberg", source_lang="en")
    assert TaleSource.model_validate_json(r.model_dump_json()) == r
