import hashlib
import json
import sqlite3
import zipfile
from pathlib import Path

import pytest

import rag.pack_builder as pb
from rag.continents import CONTINENT_OF, UnknownCountry, continent_of
from rag.io import append_jsonl
from rag.schemas import Motif, MotifExtraction, TaleRecord, Verbalization


def _tale(ref: str, cc: str, n: int, type_: str = "character") -> TaleRecord:
    ms = [Motif(id=f"{ref}-{i}", type=type_, text_en=f"hero {i}", country_code=cc, source_ref=ref) for i in range(n)]
    return TaleRecord(source_ref=ref, title=ref, extraction=MotifExtraction(), motifs=ms)


def _titles(refs: list[str], n: int) -> list[Verbalization]:
    return [Verbalization(motif_id=f"{r}-{j}", lang="cs", age_band="3-6", tone="neutral", length="title", text=f"Jméno {r}{j}") for r in refs for j in range(n)]


@pytest.fixture
def data(tmp_path: Path, monkeypatch):
    d = tmp_path / "data"
    d.mkdir()
    monkeypatch.setattr(pb, "DATA_DIR", d)
    # Ghana (Afrika): tale t0 shows 1 motif, t1 shows 3, …: readiness ranks t6 first.
    tales = [_tale(f"t{i}", "GH", 3) for i in range(7)]
    # Nigérie (Afrika) a Česko (Evropa, v binárce): úkoly, ať je vidět shown.
    tales += [_tale("ng1", "NG", 2, "task"), _tale("cz1", "CZ", 2, "task"), _tale("cz2", "CZ", 1, "ending")]
    append_jsonl(d / "tales.jsonl", tales)
    append_jsonl(d / "cards.cs.jsonl", [Verbalization(motif_id=f"t{i}-{j}", lang="cs", age_band="3-6", tone="neutral", length="title", text=f"Jméno {i}{j}") for i in range(7) for j in range(1 + i % 3)])
    append_jsonl(d / "verbalizations.cs.jsonl", _titles(["ng1", "cz1", "cz2"], 1))
    return d


def _run(d: Path, dist: Path, state: Path, countries: set[str] | None = None):
    return pb.build_all("cs", countries, embed=None, embed_model="", embed_ver="", dist=dist, state_path=state, tales_path=d / "tales.jsonl", images_dir=d / "img", scene_images_dir=d / "scn")


def test_continent_table_covers_the_globe_and_the_corpus_basics():
    geo = json.loads((Path(__file__).resolve().parents[2] / "app/assets/geo/countries.json").read_text(encoding="utf-8"))
    assert [c["i"] for c in geo if c["i"] not in CONTINENT_OF] == []
    # Natural Earth's CONTINENT, not a schoolbook guess
    assert (continent_of("RU"), continent_of("TR"), continent_of("EG"), continent_of("GL"), continent_of("JM"), continent_of("cz")) == ("EU", "AS", "AF", "NA", "NA", "EU")
    with pytest.raises(UnknownCountry):
        continent_of("ZZ")


def test_free_per_continent_paid_per_country(data: Path, tmp_path: Path):
    dist, state = tmp_path / "dist", tmp_path / "state.json"
    m = _run(data, dist, state)
    assert m["schema"] == 3
    af = m["continents"]["af"]
    assert af["countries"] == ["GH", "NG"] and af["bundled"] is False and af["name"]["cs"] == "Afrika"
    assert af["free"]["file"] == "continent-af-free-v1.zip" and af["free"]["tales"] == 6  # 5 z Ghany + 1 z Nigérie
    eu = m["continents"]["eu"]
    assert eu["bundled"] is True and eu["countries"] == ["CZ"]
    # Evropa jde do binárky jako surový SQLite soubor, týž obsah jako zip
    raw = (dist / "bundle/continent.EU.cs.free.db").read_bytes()
    with zipfile.ZipFile(dist / "free-v1/continent-eu-free-v1.zip") as z:
        assert z.read("continent.EU.cs.free.db") == raw
        meta = json.loads(z.read("pack.json"))
        assert meta["continent"] == "EU" and meta["countries"] == ["CZ"] and meta["tier"] == "free"

    gh = m["countries"]["gh"]
    assert gh["continent"] == "AF" and gh["free_tales"] == 5 and "free" not in gh
    assert gh["paid"]["tales"] == 2 and gh["paid"]["product_id"] == "pack_gh"
    assert "paid" not in m["countries"]["cz"]  # 2 pohádky, obě free
    assert "url" not in json.dumps(m["countries"])  # paid URLs are built by the client after entitlement

    sizes = json.loads((dist / "sizes.json").read_text())
    assert sizes["continent.EU"]["bundled"] is True and sizes["country.GH.paid"]["tales"] == 2


def test_pack_tales_counts_tales_per_country(data: Path, tmp_path: Path):
    dist = tmp_path / "dist"
    _run(data, dist, tmp_path / "s.json")
    with zipfile.ZipFile(dist / "free-v1/continent-af-free-v1.zip") as z:
        db = tmp_path / "af.db"
        db.write_bytes(z.read("continent.AF.cs.free.db"))
    conn = sqlite3.connect(db)
    per = dict(conn.execute("SELECT country_code, COUNT(*) FROM pack_tales GROUP BY country_code").fetchall())
    assert per == {"GH": 5, "NG": 1}
    assert conn.execute("SELECT motifs, shown FROM pack_tales WHERE source_ref = 'ng1'").fetchone() == (2, 1)  # 2 úkoly, titulek jen jeden
    assert conn.execute("SELECT SUM(shown) FROM pack_tales WHERE country_code = 'GH'").fetchone()[0] == 0  # postavy se nepočítají
    conn.close()


def test_tiers_stable_versions_bump_only_on_change(data: Path, tmp_path: Path):
    dist, state = tmp_path / "dist", tmp_path / "state.json"
    m1 = _run(data, dist, state)
    st = json.loads(state.read_text())["countries"]["GH"]
    assert len(st["free"]) == 5 and len(st["paid"]) == 2
    z1 = (dist / "free-v1/continent-af-free-v1.zip").read_bytes()

    m2 = _run(data, dist, state)  # nothing changed
    assert m2 == m1
    assert (dist / "free-v1/continent-af-free-v1.zip").read_bytes() == z1

    # a new, better tale must not push anything out of free
    append_jsonl(data / "tales.jsonl", [_tale("t9", "GH", 3)])
    append_jsonl(data / "cards.cs.jsonl", _titles(["t9"], 3))
    m3 = _run(data, dist, state)
    st3 = json.loads(state.read_text())["countries"]["GH"]
    assert st3["free"] == st["free"] and st3["paid"] == st["paid"] + ["t9"]
    assert m3["continents"]["af"]["free"]["version"] == 1
    assert m3["countries"]["gh"]["paid"]["version"] == 2
    assert (dist / "pack-gh-v2/gh-lite.zip").exists()

    # a new free tale in Nigeria bumps Africa only, Europe keeps its bytes
    eu = (dist / "bundle/continent.EU.cs.free.db").read_bytes()
    append_jsonl(data / "tales.jsonl", [_tale("ng2", "NG", 1, "task")])
    append_jsonl(data / "verbalizations.cs.jsonl", _titles(["ng2"], 1))
    m4 = _run(data, dist, state)
    assert m4["continents"]["af"]["free"]["version"] == 2 and m4["continents"]["af"]["free"]["file"] == "continent-af-free-v2.zip"
    assert m4["continents"]["eu"]["free"]["version"] == 1
    assert (dist / "bundle/continent.EU.cs.free.db").read_bytes() == eu


def test_country_filter_still_builds_the_whole_continent(data: Path, tmp_path: Path):
    dist, state = tmp_path / "dist", tmp_path / "state.json"
    _run(data, dist, state)
    m = _run(data, dist, state, countries={"NG"})
    assert m["continents"]["af"]["countries"] == ["GH", "NG"]
    assert m["continents"]["af"]["free"]["tales"] == 6


def test_zip_carries_pack_json_with_file_hashes(data: Path, tmp_path: Path):
    dist = tmp_path / "dist"
    _run(data, dist, tmp_path / "s.json")
    with zipfile.ZipFile(dist / "pack-gh-v1/gh-lite.zip") as z:
        meta = json.loads(z.read("pack.json"))
        assert meta["tier"] == "lite" and meta["country"] == "GH"
        (name, f), = meta["files"].items()
        assert hashlib.sha256(z.read(name)).hexdigest() == f["sha256"]


def test_budget_fails_the_build(data: Path, tmp_path: Path, monkeypatch):
    monkeypatch.setattr(pb, "TALE_BUDGET_BYTES", 5)
    with pytest.raises(pb.BudgetError):
        _run(data, tmp_path / "dist", tmp_path / "s.json")


def test_world_cards_go_into_continent_packs(data: Path, tmp_path: Path):
    """Karty světových task/problem/ending motivů (render-motifs do
    motif_images, 2026-10-04) se do kontinentálního balíčku zabalí;
    rozpracovaný (useknutý) soubor build neshodí."""
    from PIL import Image

    img = data / "img"
    img.mkdir()
    Image.new("RGB", (1024, 1024), (200, 100, 50)).save(img / "ng1-0.jpg")
    (img / "ng1-1.jpg").write_bytes(b"\xff\xd8\xff")  # právě se zapisuje
    dist = tmp_path / "dist"
    _run(data, dist, tmp_path / "s.json")
    with zipfile.ZipFile(dist / "free-v1/continent-af-free-v1.zip") as z:
        db = tmp_path / "af.db"
        db.write_bytes(z.read("continent.AF.cs.free.db"))
    conn = sqlite3.connect(db)
    assert [r[0] for r in conn.execute("SELECT motif_id FROM motif_images")] == ["ng1-0"]
    conn.close()


def test_czechia_is_free_whole_and_has_no_paid_pack(data: Path, tmp_path: Path):
    """Rozhodnutí 2026-10-04: celé Česko zdarma (v Evropě, tedy v binárce)."""
    more = [_tale(f"c{i}", "CZ", 1, "task") for i in range(8)]
    append_jsonl(data / "tales.jsonl", more)
    append_jsonl(data / "verbalizations.cs.jsonl", _titles([t.source_ref for t in more], 1))
    dist, state = tmp_path / "dist", tmp_path / "state.json"
    # starší stav s placeným CZ se převede do free, nic se neztratí
    state.write_text(json.dumps({"lang": "cs", "countries": {"CZ": {"free": ["cz1"], "paid": ["cz2"]}}}))
    m = _run(data, dist, state)
    st = json.loads(state.read_text())["countries"]["CZ"]
    assert st["paid"] == [] and len(st["free"]) == 10
    assert "paid" not in m["countries"]["cz"] and m["countries"]["cz"]["free_tales"] == 10
    assert m["continents"]["eu"]["free"]["tales"] == 10
    assert not list(dist.glob("pack-cz-*"))
    assert m["countries"]["gh"]["free_tales"] == 5  # ostatní dál R1



def test_scenes_pack_carries_every_scene_without_the_budget(data: Path, tmp_path: Path, monkeypatch):
    """Rozhodnutí 2026-10-05: `scenes.CZ.cs.free` nese všechny vyrenderované
    scény českých pohádek — i ty, které rozpočet na pohádku z Evropy v
    binárce ořízl — a nic dalšího, co by RagStore k nalezení scény nepotřeboval."""
    from PIL import Image

    from rag.schemas import ScenePrompt

    monkeypatch.setattr(pb, "TALE_MAX_IMAGES", 1)  # Evropa unese jen jednu scénu na pohádku
    scn = data / "scn"
    scn.mkdir()
    prompts = [ScenePrompt(id=f"s{i}", motif_id="cz1-0", environment_id="forest", phase="task", text_en=f"a long prompt {i}") for i in range(3)]
    prompts += [ScenePrompt(id="s-gh", motif_id="t0-0", environment_id=None, phase="intro", text_en="Ghana"), ScenePrompt(id="s-cut", motif_id="cz2-0", environment_id=None, phase="ending", text_en="x")]
    append_jsonl(data / "scene_prompts.jsonl", prompts)
    for sid in ("s0", "s1", "s2", "s-gh"):
        Image.new("RGB", (1024, 1024), (40, 90, 60)).save(scn / f"{sid}.jpg")
    (scn / "s-cut.jpg").write_bytes(b"\xff\xd8\xff")  # rozpracovaný render se vynechá
    dist, state = tmp_path / "dist", tmp_path / "state.json"
    m = _run(data, dist, state)

    sc = m["scenes"]["cz"]
    assert sc["name"]["cs"] == "Česko – všechny scény" and sc["country"] == "CZ"
    assert sc["free"]["file"] == "scenes-cz-v1.zip" and sc["free"]["images"] == 3
    assert m["schema"] == 3  # přidaná sekce, starší klient ji přeskočí
    with zipfile.ZipFile(dist / "free-v1/scenes-cz-v1.zip") as z:
        meta = json.loads(z.read("pack.json"))
        assert meta["id"] == "scenes.CZ.cs.free" and meta["kind"] == "scenes" and meta["images"] == 3
        db = tmp_path / "scenes.db"
        db.write_bytes(z.read("scenes.CZ.cs.free.db"))
    conn = sqlite3.connect(db)
    assert [r for r in conn.execute("SELECT id, motif_id, phase, text_en FROM scene_prompts ORDER BY id")] == [(f"s{i}", "cz1-0", "task", "") for i in range(3)]
    assert conn.execute("SELECT COUNT(*) FROM scene_images").fetchone()[0] == 3
    for t in ("motifs", "verbalizations", "hint_bank", "scene_emb", "motif_images"):
        assert conn.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0] == 0, t
    assert conn.execute("SELECT pack_id, embed_model FROM meta").fetchone() == ("scenes.CZ.cs.free", "")
    art = conn.execute("SELECT jpeg FROM scene_images LIMIT 1").fetchone()[0]
    conn.close()
    import io

    with Image.open(io.BytesIO(art)) as im:
        assert (im.format, im.size) == ("WEBP", (pb.SCENE_PX, pb.SCENE_PX))

    # Evropa v binárce dál drží rozpočet: z cz1 jen jedna scéna
    eu = sqlite3.connect(dist / "bundle/continent.EU.cs.free.db")
    assert eu.execute("SELECT COUNT(*) FROM scene_images").fetchone()[0] == 1
    eu.close()

    sizes = json.loads((dist / "sizes.json").read_text())
    assert sizes["scenes.CZ"]["images"] == 3 and sizes["scenes.CZ"]["px"] == pb.SCENE_PX
    assert json.loads(state.read_text())["scenes"]["CZ"]["version"] == 1

    # beze změny: stejná verze i bajty; nová scéna: v2
    z1 = (dist / "free-v1/scenes-cz-v1.zip").read_bytes()
    assert _run(data, dist, state)["scenes"] == m["scenes"]
    assert (dist / "free-v1/scenes-cz-v1.zip").read_bytes() == z1
    append_jsonl(data / "scene_prompts.jsonl", [ScenePrompt(id="s3", motif_id="cz2-0", environment_id=None, phase="ending", text_en="y")])
    Image.new("RGB", (1024, 1024), (90, 40, 60)).save(scn / "s3.jpg")
    m3 = _run(data, dist, state)
    assert m3["scenes"]["cz"]["free"]["version"] == 2 and m3["scenes"]["cz"]["free"]["images"] == 4


def test_no_rendered_scenes_no_scenes_pack(data: Path, tmp_path: Path):
    m = _run(data, tmp_path / "dist", tmp_path / "s.json")
    assert m["scenes"] == {}
    assert not list((tmp_path / "dist").glob("free-v1/scenes-*"))
