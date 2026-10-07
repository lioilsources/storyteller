import json
import sqlite3
import zipfile
from pathlib import Path

import pytest
from PIL import Image

import rag.pack_builder as pb
import rag.region_packs as rp
from rag import regions
from rag.io import append_jsonl
from rag.pack_check import LEVELS, Corpus, check_tale
from rag.schemas import PHASES, Hint, Motif, MotifExtraction, ScenePrompt, TaleRecord, Verbalization

TYPES = ("character", "task", "problem", "ending")


def _tale(ref: str, cc: str) -> TaleRecord:
    ms = [Motif(id=f"{ref}-{t}", type=t, text_en=f"{t} of {ref}", country_code=cc, source_ref=ref) for t in TYPES]
    return TaleRecord(source_ref=ref, title=ref, extraction=MotifExtraction(), motifs=ms)


def _ready(d: Path, refs: list[str], *, hints: int = 3, scenes: bool = True, sounds: bool = True, cards: bool = True) -> None:
    """Všechno, co pohádka potřebuje pro úroveň A."""
    (d / "motif_images").mkdir(exist_ok=True)
    (d / "scene_images").mkdir(exist_ok=True)
    for ref in refs:
        ids = [f"{ref}-{t}" for t in TYPES]
        if cards:
            append_jsonl(d / "cards.cs.jsonl", [Verbalization(motif_id=i, lang="cs", age_band="3-6", tone="neutral", length=ln, text=f"{ln} {i}") for i in ids for ln in ("title", "sentence")])
            for i in ids:
                Image.new("RGB", (64, 64), (200, 100, 50)).save(d / "motif_images" / f"{i}.jpg")
        append_jsonl(d / "hints.cs.jsonl", [Hint(id=f"h-{ref}-{t}-{n}", motif_id=f"{ref}-{t}", phase=t, environment_id=None, lang="cs", text=f"Co bylo dál {n}…", situation_en=f"The {t} of {ref}, {n}.") for t in TYPES[1:] for n in range(hints)])
        if scenes:
            sps = [ScenePrompt(id=f"s-{ref}-{t}-{p}", motif_id=f"{ref}-{t}", environment_id=None, phase=p, text_en="a scene") for t in TYPES[1:] for p in PHASES]
            append_jsonl(d / "scene_prompts.jsonl", sps)
            for s in sps:
                Image.new("RGB", (64, 64), (40, 90, 60)).save(d / "scene_images" / f"{s.id}.jpg")
        if sounds:
            with (d / "character_sounds.jsonl").open("a", encoding="utf-8") as f:
                f.write(json.dumps({"motif_id": f"{ref}-character", "sound": "creature-fox", "source": "llm"}) + "\n")
            with (d / "sound_cues.jsonl").open("a", encoding="utf-8") as f:
                for t in TYPES[1:]:
                    f.write(json.dumps({"motif_id": f"{ref}-{t}", "cues": ["action-magic", "music-forest-tense"]}) + "\n")


@pytest.fixture
def data(tmp_path: Path, monkeypatch):
    d = tmp_path / "data"
    d.mkdir()
    monkeypatch.setattr(pb, "DATA_DIR", d)
    # Afrika: 9 pohádek z Ghany, 4 z Nigérie, 1 z Keni; Česko jen 3.
    refs = [f"gh{i}" for i in range(9)] + [f"ng{i}" for i in range(4)] + ["ke0"] + [f"cz{i}" for i in range(3)]
    append_jsonl(d / "tales.jsonl", [_tale(r, r[:2].upper()) for r in refs])
    _ready(d, refs)
    return d


def _run(d: Path, tmp: Path, **kw):
    return rp.build_all("cs", kw.pop("only", None), embed=None, embed_model="", embed_ver="", dist=tmp / "dist", state_path=tmp / "state.json", data_dir=d, **kw)


def test_every_globe_country_is_in_exactly_one_region():
    geo = json.loads((Path(__file__).resolve().parents[2] / "app/assets/geo/countries.json").read_text(encoding="utf-8"))
    assert [c["i"] for c in geo if c["i"] not in regions.REGION_OF and c["i"] not in ("AQ", "TF")] == []
    assert set(regions.REGION_OF.values()) == set(regions.ORDER)
    assert (regions.region_of("cz"), regions.region_of("RU"), regions.region_of("EG"), regions.region_of("JM"), regions.region_of("AU"), regions.region_of("TR")) == ("CZSK", "EAST", "AFRI", "NAMC", "SEAO", "MEAS")
    with pytest.raises(regions.UnknownCountry):
        regions.region_of("AQ")


def test_free_ten_round_robin_and_manifest_counts(data: Path, tmp_path: Path):
    m = _run(data, tmp_path)
    assert m["schema"] == 4 and set(m["regions"]) == {"afri"}  # Česko má jen 3 pohádky: free čeká
    af = m["regions"]["afri"]
    assert af["name"]["cs"] == "Afrika" and af["bundled"] is True and af["countries"] == ["GH", "KE", "NG"]
    assert af["free"]["tales"] == 10 and af["free"]["file"] == "region-afri-free-v1.zip" and af["parts"] == []
    st = json.loads((tmp_path / "state.json").read_text())["regions"]["AFRI"]
    # na střídačku po zemích, největší první: gh, ng, ke, gh, ng, gh, ng, …
    assert st["queue"][:7] == ["gh0", "ng0", "ke0", "gh1", "ng1", "gh2", "ng2"]
    assert st["free"]["tales"] == st["queue"][:10]
    # glóbus: počty po zemích bez stahování; co v žádném dílu není, je „coming“
    assert m["countries"]["gh"] == {"name": {"en": "Ghana"}, "region": "AFRI", "tales": 5, "in": {"free": 5, "parts": {}}, "coming": 4}
    assert m["countries"]["ke"]["tales"] == 1 and m["countries"]["ng"]["in"]["free"] == 4
    assert "cz" not in m["countries"]

    raw = (tmp_path / "dist/bundle/region.AFRI.cs.free.db").read_bytes()
    with zipfile.ZipFile(tmp_path / "dist/free-v2/region-afri-free-v1.zip") as z:
        assert z.read("region.AFRI.cs.free.db") == raw
        meta = json.loads(z.read("pack.json"))
        assert meta["region"] == "AFRI" and meta["tier"] == "free" and len(meta["tales"]) == 10 and "waived" not in meta
    conn = sqlite3.connect(tmp_path / "dist/bundle/region.AFRI.cs.free.db")
    assert dict(conn.execute("SELECT country_code, COUNT(*) FROM pack_tales GROUP BY 1").fetchall()) == {"GH": 5, "NG": 4, "KE": 1}
    assert conn.execute("SELECT sound_id, role FROM motif_sounds WHERE motif_id = 'gh0-character'").fetchall() == [("creature-fox", "character")]
    assert conn.execute("SELECT COUNT(*) FROM motif_sounds WHERE role = 'cue'").fetchone()[0] == 60
    conn.close()


def test_failing_tale_waits_and_the_next_in_queue_takes_its_place(data: Path, tmp_path: Path):
    # gh1 nemá scény: free si vezme 11. pohádku fronty, gh1 zůstane čekat
    lines = [ln for ln in (data / "scene_prompts.jsonl").read_text().splitlines() if '"gh1-' not in ln]
    (data / "scene_prompts.jsonl").write_text("\n".join(lines) + "\n")
    m = _run(data, tmp_path)
    st = json.loads((tmp_path / "state.json").read_text())["regions"]["AFRI"]
    assert "gh1" not in st["free"]["tales"] and st["free"]["tales"] == [r for r in st["queue"] if r != "gh1"][:10]
    assert m["countries"]["gh"]["coming"] == 4

    c = Corpus.load("cs", data_dir=data)
    assert set(check_tale(c, "gh1", LEVELS["A"])) == {"scenes"}
    assert check_tale(c, "gh0", LEVELS["A"]) == {}
    assert set(check_tale(c, "gh0", LEVELS["B"])) == {"hints", "verbalizations"}  # B: 5 nápověd ve všech fázích, 12 variant


def test_free_waits_until_ten_pass_and_waive_is_written_into_the_pack(data: Path, tmp_path: Path):
    more = [f"cz{i}" for i in range(3, 10)]
    append_jsonl(data / "tales.jsonl", [_tale(r, "CZ") for r in more])
    _ready(data, more, sounds=False)
    assert "czsk" not in _run(data, tmp_path)["regions"]  # 7 z 10 bez zvuku postavy
    m = _run(data, tmp_path, waive=frozenset({"sounds"}))
    assert m["regions"]["czsk"]["free"]["tales"] == 10
    with zipfile.ZipFile(tmp_path / "dist/free-v2/region-czsk-free-v1.zip") as z:
        assert json.loads(z.read("pack.json"))["waived"] == ["sounds"]


def test_frozen_free_keeps_its_tales_and_bytes(data: Path, tmp_path: Path):
    m1 = _run(data, tmp_path)
    z1 = (tmp_path / "dist/free-v2/region-afri-free-v1.zip").read_bytes()
    free = json.loads((tmp_path / "state.json").read_text())["regions"]["AFRI"]["free"]["tales"]
    assert _run(data, tmp_path) == m1
    assert (tmp_path / "dist/free-v2/region-afri-free-v1.zip").read_bytes() == z1

    # nová, lepší pohádka jde na konec fronty a z free nikoho nevytlačí
    append_jsonl(data / "tales.jsonl", [_tale("gh99", "GH")])
    _ready(data, ["gh99"])
    m2 = _run(data, tmp_path)
    st = json.loads((tmp_path / "state.json").read_text())["regions"]["AFRI"]
    assert st["free"]["tales"] == free and st["queue"][-1] == "gh99"
    assert m2["regions"]["afri"]["free"]["version"] == 1 and m2["countries"]["gh"]["coming"] == 5

    # oprava obsahu zmrazeného dílu = nová verze, stejné pohádky
    append_jsonl(data / "hints.cs.jsonl", [Hint(id="h-extra", motif_id="gh0-task", phase="task", environment_id=None, lang="cs", text="A pak…", situation_en="Later.")])
    m3 = _run(data, tmp_path)
    assert m3["regions"]["afri"]["free"]["version"] == 2 and m3["regions"]["afri"]["free"]["file"] == "region-afri-free-v2.zip"
    assert json.loads((tmp_path / "state.json").read_text())["regions"]["AFRI"]["free"]["tales"] == free


def test_parts_of_fifty_only_when_fifty_pass(data: Path, tmp_path: Path, monkeypatch):
    monkeypatch.setattr(rp, "PART_TALES", 2)
    monkeypatch.setitem(rp.LEVELS, "B", LEVELS["A"])
    more = [f"ng{i}" for i in range(4, 7)]  # Afrika: 14 + 3 = 17 → free 10, díly 2+2+2, jedna čeká
    append_jsonl(data / "tales.jsonl", [_tale(r, "NG") for r in more])
    _ready(data, more)
    m = _run(data, tmp_path)
    parts = m["regions"]["afri"]["parts"]
    assert [(p["n"], p["product_id"], p["tales"], p["file"]) for p in parts] == [(1, "pack_afri_1", 2, "afri-p1.zip"), (2, "pack_afri_2", 2, "afri-p2.zip"), (3, "pack_afri_3", 2, "afri-p3.zip")]
    assert (tmp_path / "dist/region-afri-p2-v1/afri-p2.zip").exists()
    assert sum(c["coming"] for c in m["countries"].values()) == 1
    total = sum(c["in"]["free"] + sum(c["in"]["parts"].values()) for c in m["countries"].values())
    assert total == 16 == sum(c["tales"] for c in m["countries"].values())
    st = json.loads((tmp_path / "state.json").read_text())["regions"]["AFRI"]
    packed = st["free"]["tales"] + [r for p in st["parts"] for r in p["tales"]]
    assert len(packed) == len(set(packed)) == 16  # žádná pohádka ve dvou dílech
    assert not list((tmp_path / "dist/bundle").glob("*p1*"))  # do binárky jen free


def test_flawed_tales_go_to_the_end_of_the_queue_and_plan_lists_what_is_missing(data: Path, tmp_path: Path):
    append_jsonl(data / "tales.jsonl", [_tale("gh-cyr", "GH"), _tale("gh-nocard", "GH")])
    _ready(data, ["gh-cyr"])
    append_jsonl(data / "cards.cs.jsonl", [Verbalization(motif_id="gh-cyr-task", lang="cs", age_band="3-6", tone="neutral", length="sentence", text="Princ zvolil сестру.")])
    append_jsonl(data / "cards.cs.jsonl", [Verbalization(motif_id="gh-nocard-task", lang="cs", age_band="3-6", tone="neutral", length="title", text="Úkol")])
    _run(data, tmp_path, plan_only=True)
    state = json.loads((tmp_path / "state.json").read_text())
    q = state["regions"]["AFRI"]["queue"]
    assert set(q[-2:]) == {"gh-cyr", "gh-nocard"} and "free" not in state["regions"]["AFRI"]
    assert not (tmp_path / "dist").exists()
    rows = rp.plan_rows(state, Corpus.load("cs", data_dir=data))
    assert [o["pack"] for o in rows[:13]] == ["free"] * 13  # 10 z Afriky + 3 z Česka, regiony na střídačku
    assert rows[0]["region"] == "CZSK" and rows[1]["region"] == "AFRI" and rows[0]["missing"] == []
    by = {o["source_ref"]: o for o in rows}
    assert by["gh-cyr"]["pack"] == "p1" and "texts" in by["gh-cyr"]["missing"] and by["gh-cyr"]["partial"] is True
    assert {"motifs", "cards"} <= set(by["gh-nocard"]["missing"])


def test_other_regions_stay_in_the_manifest_when_one_is_built(data: Path, tmp_path: Path):
    more = [f"cz{i}" for i in range(3, 10)]
    append_jsonl(data / "tales.jsonl", [_tale(r, "CZ") for r in more])
    _ready(data, more)
    m = _run(data, tmp_path)
    assert list(m["regions"]) == ["czsk", "afri"]  # pořadí regions.ORDER
    m2 = _run(data, tmp_path, only={"CZSK"})
    assert m2 == m
