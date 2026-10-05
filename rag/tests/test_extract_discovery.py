"""Discovery and provenance for the two on-disk corpus layouts.

`fetch-gutenberg` writes one directory per book; `fetch-wikisource`
writes one `tales/` directory per collection. Until 2026-09-25 discovery
matched only `*-tales`, so the whole Czech corpus sat on disk and was
never seen — no error, just 150 tales that quietly did not exist.
"""

import json
from pathlib import Path

from rag.extract import KNOWN_COUNTRY, MIXED_ORIGIN, NO_COUNTRY, discover_tales, source_ref


def _write(root: Path, rel: str, entries: list[tuple[str, str]]) -> None:
    d = root / rel
    d.mkdir(parents=True, exist_ok=True)
    index = []
    for i, (title, fname) in enumerate(entries):
        (d / fname).write_text(f"text of {title}", encoding="utf-8")
        index.append({"idx": i, "title": title, "file": fname})
    (d / "index.json").write_text(json.dumps(index), encoding="utf-8")


def test_discovers_both_layouts(tmp_path: Path) -> None:
    _write(tmp_path, "grimm/2591-tales", [("The Golden Bird", "000-the-golden-bird.txt")])
    _write(tmp_path, "nemcova/tales", [("Chytrá horákyně", "000-chytra-horakyne.txt")])

    found = discover_tales(tmp_path, set())
    by_coll = {c: (src, book, title) for src, c, book, title, _ in found}

    assert by_coll["grimm"] == ("gutenberg", "2591", "The Golden Bird")
    assert by_coll["nemcova"] == ("wikisource", "", "Chytrá horákyně")


def test_gutenberg_refs_are_unchanged(tmp_path: Path) -> None:
    # The 93 tales extracted before this change carry exactly this shape.
    # Any drift re-extracts all of them and doubles their motifs.
    path = tmp_path / "000-the-golden-bird.txt"
    assert source_ref("gutenberg", "grimm", "2591", path) == "gutenberg:grimm:2591:000-the-golden-bird"


def test_wikisource_refs_drop_the_empty_book_id(tmp_path: Path) -> None:
    path = tmp_path / "000-chytra-horakyne.txt"
    assert source_ref("wikisource", "nemcova", "", path) == "wikisource:nemcova:000-chytra-horakyne"


def test_directories_without_an_index_are_skipped(tmp_path: Path) -> None:
    # `fetch-wikisource` also writes meta.json next to tales/, and a
    # half-finished run can leave a directory with no index at all.
    (tmp_path / "nemcova" / "notes").mkdir(parents=True)
    _write(tmp_path, "nemcova/tales", [("Chytrá horákyně", "000-chytra-horakyne.txt")])
    assert len(discover_tales(tmp_path, set())) == 1


def test_only_filter_applies_to_collections(tmp_path: Path) -> None:
    _write(tmp_path, "grimm/2591-tales", [("A", "a.txt")])
    _write(tmp_path, "nemcova/tales", [("B", "b.txt")])
    assert {c for _, c, _, _, _ in discover_tales(tmp_path, {"nemcova"})} == {"nemcova"}


def test_every_fetched_collection_has_an_origin_rule() -> None:
    """Each collection is either single-country or explicitly mixed.

    Getting this wrong is not a crash, it's a wrong map: a Lang tale from
    Japan tagged DE would colour the globe with a lie. `lang` and
    `erben-slovanske` gather many nations on purpose and must stay out of
    KNOWN_COUNTRY so the model decides per tale.
    """
    import re
    from pathlib import Path

    repo = Path(__file__).resolve().parents[2]
    gutenberg = set(re.findall(r'Collection: "([^"]+)"', (repo / "corpus/internal/gutenberg/catalog.go").read_text()))
    fetched = gutenberg | {"nemcova", "erben", "erben-slovanske", "nemcova-srbske"}
    missing = fetched - set(KNOWN_COUNTRY) - MIXED_ORIGIN - NO_COUNTRY
    assert not missing, f"collections with no origin rule: {sorted(missing)}"
    assert not (set(KNOWN_COUNTRY) & MIXED_ORIGIN)
    assert {"lang", "erben-slovanske"} <= MIXED_ORIGIN
    # Němcová translated Serbian tales into Czech; the tradition is the
    # tale's, not the translation's.
    assert KNOWN_COUNTRY["nemcova-srbske"] == "RS"
    assert KNOWN_COUNTRY["nemcova"] == "CZ"


def test_front_matter_is_not_a_tale() -> None:
    from rag.extract import is_front_matter

    for t in ["Introduction", "PREFACE", "_Glossary_", "Index to Informants", "Pronunciation of Philippine Names", "NATIVE TEXT OF THE FIRST TALE (APPENDIX)"]:
        assert is_front_matter(t), t
    for t in ["THE END OF THE WORLD", "The Introduced Stranger's Luck", "Notable Nightingale", "The Golden Bird"]:
        assert not is_front_matter(t), t



def test_archive_books_keep_their_source(tmp_path: Path) -> None:
    # Internet Archive books share fetch-gutenberg's layout; the sidecar
    # says where they came from, and source_ref must not claim Gutenberg.
    _write(tmp_path, "skeat-malay/fablesandfolktal00skeauoft-tales", [("A Malayan Deluge", "022-a-malayan-deluge.txt")])
    (tmp_path / "skeat-malay/fablesandfolktal00skeauoft.json").write_text(json.dumps({"source": "archive"}), encoding="utf-8")
    _write(tmp_path, "grimm/2591-tales", [("The Golden Bird", "000-the-golden-bird.txt")])
    (tmp_path / "grimm/2591.json").write_text(json.dumps({"id": 2591}), encoding="utf-8")  # pre-wave-2 sidecar

    refs = {source_ref(s, c, b, p) for s, c, b, _, p in discover_tales(tmp_path, set())}
    assert refs == {
        "archive:skeat-malay:fablesandfolktal00skeauoft:022-a-malayan-deluge",
        "gutenberg:grimm:2591:000-the-golden-bird",
    }


def test_tale_country_outranks_the_model_but_not_no_country(tmp_path: Path) -> None:
    from rag.extract import country_for, tale_country

    d = tmp_path / "finger-silver-lands/68292-tales"
    d.mkdir(parents=True)
    (d / "016-the-tale-of-the-lazy-people.txt").write_text("In Colombia, it seems…", encoding="utf-8")
    (d / "001-the-magic-dog.txt").write_text("Down where the forest…", encoding="utf-8")
    (d / "index.json").write_text(json.dumps([
        {"idx": 1, "title": "The Magic Dog", "file": "001-the-magic-dog.txt"},
        {"idx": 16, "title": "The Tale of the Lazy People", "file": "016-the-tale-of-the-lazy-people.txt", "country": "CO"},
    ]), encoding="utf-8")

    lazy = tale_country(d / "016-the-tale-of-the-lazy-people.txt")
    dog = tale_country(d / "001-the-magic-dog.txt")
    assert (lazy, dog) == ("CO", "")
    assert country_for("finger-silver-lands", "PE", lazy) == "CO"
    assert country_for("finger-silver-lands", "PE", dog) == "PE"
    assert country_for("tibet-jewett", "CN", "CN") == ""
