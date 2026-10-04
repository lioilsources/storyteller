"""Země → kontinent pro free balíčky po kontinentech
(STORYTELLER_MONETIZATION_PLAN.md §4, §11: rozhodnutí 2026-10-03).

Glóbus má geometrii z Natural Earth 110m (`corpus/cmd/build-geo`), jenže
asset `app/assets/geo/countries.json` kontinent nenese a zdrojový GeoJSON
v repu neleží. Proto tabulka ISO 3166-1 alpha-2 → kontinent, vyplněná
podle pole CONTINENT z Natural Earth admin-0 (tam, kde ho NE má), takže
hranice sedí s tím, co glóbus kreslí:

    RU → Evropa, TR/CY/GE/AM/AZ/KZ → Asie, EG → Afrika,
    GL a Karibik → Severní Amerika, GU/FJ/PG → Oceánie.

Země, které 110m vůbec nemá (mikrostáty, ostrovy), jsou doplněné podle
zeměpisu. Kód kontinentu je dvoupísmenný (EU, AF, AS, NA, SA, OC, AN);
koliduje s ISO zemí (AF = Afghánistán), proto id balíčku vždy nese
prefix `continent.` a manifest má kontinenty ve vlastní sekci.
"""

from __future__ import annotations

NAMES: dict[str, dict[str, str]] = {
    "EU": {"cs": "Evropa", "en": "Europe"},
    "AF": {"cs": "Afrika", "en": "Africa"},
    "AS": {"cs": "Asie", "en": "Asia"},
    "NA": {"cs": "Severní Amerika", "en": "North America"},
    "SA": {"cs": "Jižní Amerika", "en": "South America"},
    "OC": {"cs": "Oceánie", "en": "Oceania"},
    "AN": {"cs": "Antarktida", "en": "Antarctica"},
}

# Kontinent, který je ve výchozím stavu v binárce appky (core + free Evropa).
BUNDLED = frozenset({"EU"})

_TABLE = {
    "EU": "AD AL AT AX BA BE BG BY CH CZ DE DK EE ES FI FO FR GB GG GI GR HR HU IE IM IS IT JE LI LT LU LV MC MD ME MK MT NL NO PL PT RO RS RU SE SI SJ SK SM UA VA XK",
    "AF": "AO BF BI BJ BW CD CF CG CI CM CV DJ DZ EG EH ER ET GA GH GM GN GQ GW KE KM LR LS LY MA MG ML MR MU MW MZ NA NE NG RE RW SC SD SH SL SN SO SS ST SZ TD TG TN TZ UG YT ZA ZM ZW",
    "AS": "AE AF AM AZ BD BH BN BT CN CY GE HK ID IL IN IO IQ IR JO JP KG KH KP KR KW KZ LA LB LK MM MN MO MV MY NP OM PH PK PS QA SA SG SY TH TJ TL TM TR TW UZ VN YE",
    "NA": "AG AI AW BB BL BM BQ BS BZ CA CR CU CW DM DO GD GL GP GT HN HT JM KN KY LC MF MQ MS MX NI PA PM PR SV SX TC TT US VC VG VI",
    "SA": "AR BO BR CL CO EC FK GF GY PE PY SR UY VE",
    "OC": "AS AU CK FJ FM GU KI MH MP NC NF NR NU NZ PF PG PN PW SB TK TO TV UM VU WF WS",
    "AN": "AQ BV GS HM TF",
}

CONTINENT_OF: dict[str, str] = {iso: k for k, isos in _TABLE.items() for iso in isos.split()}


class UnknownCountry(KeyError):
    pass


def continent_of(iso: str) -> str:
    """Kontinent země; neznámý kód shodí build, ať se země tiše neztratí."""
    try:
        return CONTINENT_OF[iso.upper()]
    except KeyError:
        raise UnknownCountry(f"{iso}: chybí v rag/rag/continents.py") from None
