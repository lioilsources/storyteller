"""Produkty obchodů pro placené díly (STORYTELLER_PACKS_V2_PLAN.md §1,
STORYTELLER_MONETIZATION_PLAN.md §7).

Každý zmrazený díl `region.<KOD>.<lang>.p<N>` je jeden non-consumable
produkt `pack_<kod>_<N>`, jedna cena pro všechny díly: 0,99 USD
(rozhodnutí uživatele 2026-10-25; ostatní země dopočítá Apple). Produkt vzniká, až
když je díl postavený (je v `packs-state.v2.<lang>.json`): nepoužitý
produkt mate review. ID produktu je navždy — nikdy ho nepřejmenovávej ani
znovu nepoužívej.

    python -m rag.store_products                      # seznam → store/iap_products.csv
    python -m rag.store_products --asc                # co chybí v App Store Connect (jen čte)
    python -m rag.store_products --asc --apply        # založí chybějící za 0,99 USD

`--asc` potřebuje klíč App Store Connect API: `ASC_KEY_ID`, `ASC_ISSUER_ID`
a `ASC_KEY_PATH` (AuthKey_*.p8, Distribution/Apple/_Keys). JWT podepisuje
`openssl`, žádná další závislost. Screenshot pro review a odeslání
s verzí appky zůstávají ruční (store/iap.md).
"""

from __future__ import annotations

import argparse
import base64
import csv
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

from . import regions

ROOT = Path(__file__).resolve().parents[2]
PRICE_USD = "0.99"  # každý díl, vždy stejně
BUNDLE_ID = "com.ol1n.storyteller"
COLUMNS = ["product_id", "region", "part", "tales", "name_cs", "name_en", "description_cs", "description_en"]
# Limity App Store Connect: zobrazovaný název 30, popis 45 znaků.
NAME_MAX, DESC_MAX = 30, 45
# Kratší jména tam, kde se celé i s číslem dílu do 30 znaků nevejde.
SHORT = {
    "MEDI": {"en": "Italy, Greece, Balkans"},
    "EAST": {"en": "Eastern Europe"},
    "NAMC": {"en": "North America & Caribbean"},
}


def product_id(region: str, n: int) -> str:
    return f"pack_{region.lower()}_{n}"


def rows(state: dict) -> list[dict]:
    """Řádek na každý zmrazený díl, v pořadí regionů appky."""
    out = []
    for code in regions.ORDER:
        for i, part in enumerate(state["regions"].get(code, {}).get("parts", []), 1):
            n = part.get("n", i)
            name = {**regions.NAMES[code], **SHORT.get(code, {})}
            r = {
                "product_id": product_id(code, n),
                "region": code,
                "part": n,
                "tales": len(part["tales"]),
                "name_cs": f"{name['cs']} {n}",
                "name_en": f"{name['en']} {n}",
                "description_cs": f"{len(part['tales'])} pohádek k vyprávění, díl {n}",
                "description_en": f"{len(part['tales'])} more tales to tell, part {n}",
            }
            for k, limit in (("name_cs", NAME_MAX), ("name_en", NAME_MAX), ("description_cs", DESC_MAX), ("description_en", DESC_MAX)):
                if len(r[k]) > limit:
                    raise ValueError(f"{r['product_id']} {k} má přes {limit} znaků (App Store Connect): {r[k]!r}")
            out.append(r)
    return out


def write_csv(rs: list[dict], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=COLUMNS)
        w.writeheader()
        w.writerows(rs)


# --- App Store Connect API -------------------------------------------------


def _b64(b: bytes) -> str:
    return base64.urlsafe_b64encode(b).rstrip(b"=").decode()


def _der_to_raw(der: bytes) -> bytes:
    """ECDSA podpis z openssl (DER SEQUENCE{r, s}) → r||s po 32 bajtech (JWS ES256)."""
    assert der[0] == 0x30
    i = 2 if der[1] < 0x80 else 2 + (der[1] & 0x7F)
    out = b""
    for _ in range(2):
        assert der[i] == 0x02
        n = der[i + 1]
        out += der[i + 2 : i + 2 + n].lstrip(b"\0").rjust(32, b"\0")
        i += 2 + n
    return out


def asc_token(key_id: str, issuer: str, key_path: str, now: int | None = None) -> str:
    now = int(now or time.time())
    head = _b64(json.dumps({"alg": "ES256", "kid": key_id, "typ": "JWT"}).encode())
    body = _b64(json.dumps({"iss": issuer, "iat": now, "exp": now + 15 * 60, "aud": "appstoreconnect-v1"}).encode())
    signing = f"{head}.{body}".encode()
    der = subprocess.run(["openssl", "dgst", "-sha256", "-sign", key_path], input=signing, capture_output=True, check=True).stdout
    return f"{head}.{body}.{_b64(_der_to_raw(der))}"


class Asc:
    BASE = "https://api.appstoreconnect.apple.com"

    def __init__(self, token: str):
        self.token = token

    def call(self, method: str, path: str, body: dict | None = None) -> dict:
        req = urllib.request.Request(self.BASE + path, method=method, data=None if body is None else json.dumps(body).encode(),
                                     headers={"Authorization": f"Bearer {self.token}", "Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                raw = r.read()
        except urllib.error.HTTPError as e:
            raise SystemExit(f"ASC {method} {path}: {e.code} {e.read().decode()[:800]}") from None
        return json.loads(raw) if raw else {}

    def all(self, path: str) -> list[dict]:
        out, nxt = [], path
        while nxt:
            page = self.call("GET", nxt)
            out += page.get("data", [])
            nxt = page.get("links", {}).get("next", "").removeprefix(self.BASE) or None
        return out

    def app_id(self) -> str:
        apps = self.call("GET", f"/v1/apps?filter[bundleId]={BUNDLE_ID}")["data"]
        if not apps:
            raise SystemExit(f"V App Store Connect není appka {BUNDLE_ID}.")
        return apps[0]["id"]

    def existing(self, app: str) -> dict[str, str]:
        return {p["attributes"]["productId"]: p["id"] for p in self.all(f"/v1/apps/{app}/inAppPurchasesV2?limit=200")}

    def create(self, app: str, r: dict, price_usd: str, territories: list[str]) -> str:
        rel = lambda t, i: {"data": {"type": t, "id": i}}  # noqa: E731
        iap = self.call("POST", "/v2/inAppPurchases", {"data": {
            "type": "inAppPurchases",
            "attributes": {"name": r["product_id"], "productId": r["product_id"], "inAppPurchaseType": "NON_CONSUMABLE"},
            "relationships": {"app": rel("apps", app)}}})["data"]["id"]
        # reviewNote a familySharable API odmítá při POST i PATCH (409
        # ATTRIBUTE.NOT_ALLOWED, 2026-10-27): nastavují se ručně (store/iap.md).
        self.fill(iap, r, price_usd, territories)
        return iap

    def fill(self, iap: str, r: dict, price_usd: str, territories: list[str]) -> None:
        """Texty, cena a dostupnost založeného produktu."""
        rel = lambda t, i: {"data": {"type": t, "id": i}}  # noqa: E731
        for locale, name, desc in (("cs", r["name_cs"], r["description_cs"]), ("en-US", r["name_en"], r["description_en"])):
            self.call("POST", "/v1/inAppPurchaseLocalizations", {"data": {
                "type": "inAppPurchaseLocalizations", "attributes": {"locale": locale, "name": name, "description": desc},
                "relationships": {"inAppPurchaseV2": rel("inAppPurchases", iap)}}})
        points = self.all(f"/v2/inAppPurchases/{iap}/pricePoints?filter[territory]=USA&limit=200")
        point = next((p["id"] for p in points if p["attributes"]["customerPrice"] == price_usd), None)
        if point is None:
            raise SystemExit(f"{r['product_id']}: USA nemá cenový bod {price_usd} USD.")
        self.call("POST", "/v1/inAppPurchasePriceSchedules", {
            "data": {"type": "inAppPurchasePriceSchedules", "relationships": {
                "inAppPurchase": rel("inAppPurchases", iap), "baseTerritory": rel("territories", "USA"),
                "manualPrices": {"data": [{"type": "inAppPurchasePrices", "id": "${price}"}]}}},
            "included": [{"type": "inAppPurchasePrices", "id": "${price}", "attributes": {"startDate": None},
                          "relationships": {"inAppPurchasePricePoint": rel("inAppPurchasePricePoints", point)}}]})
        self.call("POST", "/v1/inAppPurchaseAvailabilities", {"data": {
            "type": "inAppPurchaseAvailabilities", "attributes": {"availableInNewTerritories": True},
            "relationships": {"inAppPurchase": rel("inAppPurchases", iap),
                              "availableTerritories": {"data": [{"type": "territories", "id": t} for t in territories]}}}})


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", default="cs")
    ap.add_argument("--state", type=Path, help="packs-state.v2.<lang>.json (výchozí rag/)")
    ap.add_argument("--csv", type=Path, default=ROOT / "store" / "iap_products.csv")
    ap.add_argument("--asc", action="store_true", help="porovnat s App Store Connect")
    ap.add_argument("--apply", action="store_true", help="s --asc: založit chybějící produkty")
    ap.add_argument("--price-usd", default=PRICE_USD, help=f"základní cena v USA (výchozí {PRICE_USD})")
    a = ap.parse_args()

    state = json.loads((a.state or ROOT / "rag" / f"packs-state.v2.{a.lang}.json").read_text())
    rs = rows(state)
    write_csv(rs, a.csv)
    print(f"{len(rs)} produktů → {a.csv}")
    for r in rs:
        print(f"  {r['product_id']:<16} {r['name_cs']:<30} {r['tales']} pohádek")
    if not a.asc:
        return
    try:
        token = asc_token(os.environ["ASC_KEY_ID"], os.environ["ASC_ISSUER_ID"], os.environ["ASC_KEY_PATH"])
    except KeyError as e:
        raise SystemExit(f"Chybí proměnná {e} (ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH).") from None
    asc = Asc(token)
    app = asc.app_id()
    have = asc.existing(app)
    missing = [r for r in rs if r["product_id"] not in have]
    print(f"App Store Connect: {len(have)} produktů, chybí {len(missing)}: {', '.join(r['product_id'] for r in missing) or '—'}")
    if not a.apply or not missing:
        return
    territories = [t["id"] for t in asc.all("/v1/territories?limit=200")]
    for r in missing:
        iap = asc.create(app, r, a.price_usd, territories)
        print(f"  založeno {r['product_id']} ({iap}); screenshot pro review nahraj ručně")
    sys.stdout.flush()


if __name__ == "__main__":
    main()
