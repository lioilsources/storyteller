"""Země → region balíčků v2 (STORYTELLER_PACKS_V2_PLAN.md §1.1, schváleno
2026-10-07).

Region je skupina zemí, které k sobě jazykově nebo kulturně patří a
dohromady dají aspoň jeden díl po 50 pohádkách. Free desítka i placené
díly se staví po regionech (`rag.region_packs`), země vlastní balíček
nemá. Každá země glóbu je právě v jednom regionu; neznámý kód shodí
build, ať se země tiše neztratí.

Nejsou to kontinenty (`continents.py`, staré balíčky schema 3) ani
vizuální regiony glóbu (`app/assets/geo/regions.json`, slučování malých
zemí při oddálení) — ty tři tabulky se shodovat nemusí. Afrika, Severní
a Jižní Amerika se s kontinentem kryjí, proto se berou z něj; Evropa
a Asie jsou rozdělené ručně.
"""

from __future__ import annotations

from .continents import CONTINENT_OF

# Pořadí je pořadí v appce i v reportech: doma, Evropa, Asie, Afrika, Amerika.
NAMES: dict[str, dict[str, str]] = {
    "CZSK": {"cs": "Česko a Slovensko", "en": "Czechia and Slovakia"},
    "DACH": {"cs": "Německy mluvící země", "en": "German-speaking lands"},
    "BRIT": {"cs": "Britské ostrovy", "en": "British Isles"},
    "FRBX": {"cs": "Francie a Benelux", "en": "France and Benelux"},
    "IBER": {"cs": "Iberie", "en": "Iberia"},
    "MEDI": {"cs": "Itálie, Řecko a Balkán", "en": "Italy, Greece and the Balkans"},
    "NORD": {"cs": "Sever", "en": "The North"},
    "EAST": {"cs": "Východní Evropa a Kavkaz", "en": "Eastern Europe and the Caucasus"},
    "INDI": {"cs": "Indie a jižní Asie", "en": "India and South Asia"},
    "EASI": {"cs": "Východní Asie", "en": "East Asia"},
    "SEAO": {"cs": "Jihovýchodní Asie a Oceánie", "en": "Southeast Asia and Oceania"},
    "MEAS": {"cs": "Blízký východ a Střední Asie", "en": "Middle East and Central Asia"},
    "AFRI": {"cs": "Afrika", "en": "Africa"},
    "NAMC": {"cs": "Severní Amerika a Karibik", "en": "North America and the Caribbean"},
    "SAME": {"cs": "Jižní Amerika", "en": "South America"},
}

# Evropa a Asie ručně; mikrostáty a závislá území k sousedovi, jehož
# pohádky sdílejí.
_TABLE = {
    "CZSK": "CZ SK",
    "DACH": "DE AT CH LI",
    "BRIT": "GB IE IM GG JE",
    "FRBX": "FR BE NL LU MC",
    "IBER": "ES PT AD GI",
    "MEDI": "IT GR RO RS BG HR SI AL MK BA ME XK MT SM VA",
    "NORD": "DK NO SE FI IS EE LV LT FO AX SJ",
    "EAST": "RU UA BY PL HU MD GE AM AZ",
    "INDI": "IN LK PK BD NP BT AF MV IO",
    "EASI": "CN JP KR KP MN TW HK MO",
    "SEAO": "PH MY LA MM TH VN KH ID BN TL SG",
    "MEAS": "TR IR IQ SY JO IL PS LB SA YE AE OM KW QA BH CY KZ KG TJ TM UZ",
}
_CONTINENT = {"AF": "AFRI", "NA": "NAMC", "SA": "SAME", "OC": "SEAO"}

REGION_OF: dict[str, str] = {iso: _CONTINENT[k] for iso, k in CONTINENT_OF.items() if k in _CONTINENT}
for _k, _isos in _TABLE.items():
    for _iso in _isos.split():
        if _iso in REGION_OF:
            raise RuntimeError(f"{_iso} je ve dvou regionech ({REGION_OF[_iso]}, {_k})")
        REGION_OF[_iso] = _k

ORDER: tuple[str, ...] = tuple(NAMES)


class UnknownCountry(KeyError):
    pass


def region_of(iso: str) -> str:
    """Region země; neznámý kód (i Antarktida — odtud pohádky nejsou) shodí build."""
    try:
        return REGION_OF[iso.upper()]
    except KeyError:
        raise UnknownCountry(f"{iso}: chybí v rag/rag/regions.py") from None


def countries_of(region: str) -> list[str]:
    return sorted(iso for iso, k in REGION_OF.items() if k == region)
