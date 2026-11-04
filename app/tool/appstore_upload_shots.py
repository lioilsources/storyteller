#!/usr/bin/env python3
"""Upload the localized screenshots (tool/appstore_captions.py) to an editable
App Store version, and optionally its texts (What's New, keywords, ...).

    python3 tool/appstore_upload_shots.py 1.8.1                      # what would change (reads only)
    python3 tool/appstore_upload_shots.py 1.8.1 --apply              # replace screenshots in every locale
    python3 tool/appstore_upload_shots.py 1.8.1 --apply --metadata ../store/metadata/1.8.1.json
    python3 tool/appstore_upload_shots.py 1.8.1 --apply --locales en-US,sk

The version must exist and be editable (Prepare for Submission). Locales the
version does not have yet are created. Submitting for review stays manual.

Needs an App Store Connect API key with the App Manager role (a Developer key
reads but gets 403 on every metadata change): ASC_KEY_ID, ASC_ISSUER_ID,
ASC_KEY_PATH. The JWT is signed with `openssl`, no extra dependency.
"""
import base64
import hashlib
import json
import os
import pathlib
import subprocess
import sys
import time
import urllib.error
import urllib.request

APP = pathlib.Path(__file__).resolve().parent.parent
SHOTS = APP / "build" / "appstore_screenshots"
BUNDLE_ID = "com.ol1n.storyteller"
BASE = "https://api.appstoreconnect.apple.com"
# build/appstore_screenshots/<locale>/<target> → App Store Connect slot.
DISPLAY = {"iphone-6.9": "APP_IPHONE_67", "ipad-13": "APP_IPAD_PRO_3GEN_129"}


def _b64(b: bytes) -> str:
    return base64.urlsafe_b64encode(b).rstrip(b"=").decode()


def _der_to_raw(der: bytes) -> bytes:
    i = 2 if der[1] < 0x80 else 2 + (der[1] & 0x7F)
    out = b""
    for _ in range(2):
        n = der[i + 1]
        out += der[i + 2 : i + 2 + n].lstrip(b"\0").rjust(32, b"\0")
        i += 2 + n
    return out


def token() -> str:
    try:
        kid, iss, path = os.environ["ASC_KEY_ID"], os.environ["ASC_ISSUER_ID"], os.environ["ASC_KEY_PATH"]
    except KeyError as e:
        raise SystemExit(f"missing {e} (ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH)") from None
    now = int(time.time())
    head = _b64(json.dumps({"alg": "ES256", "kid": kid, "typ": "JWT"}).encode())
    body = _b64(json.dumps({"iss": iss, "iat": now, "exp": now + 19 * 60, "aud": "appstoreconnect-v1"}).encode())
    der = subprocess.run(["openssl", "dgst", "-sha256", "-sign", path], input=f"{head}.{body}".encode(),
                         capture_output=True, check=True).stdout
    return f"{head}.{body}.{_b64(_der_to_raw(der))}"


class Asc:
    def __init__(self):
        self.tok, self.born = token(), time.time()

    def call(self, method, path, body=None):
        if time.time() - self.born > 15 * 60:  # 196 uploads outlive one token
            self.tok, self.born = token(), time.time()
        req = urllib.request.Request(path if path.startswith("http") else BASE + path, method=method,
                                     data=None if body is None else json.dumps(body).encode(),
                                     headers={"Authorization": f"Bearer {self.tok}", "Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req, timeout=120) as r:
                raw = r.read()
        except urllib.error.HTTPError as e:
            raise SystemExit(f"ASC {method} {path}: {e.code} {e.read().decode()[:600]}") from None
        return json.loads(raw) if raw else {}

    def data(self, path):
        return self.call("GET", path)["data"]


def upload(asc, set_id, path: pathlib.Path):
    blob = path.read_bytes()
    shot = asc.call("POST", "/v1/appScreenshots", {"data": {
        "type": "appScreenshots", "attributes": {"fileName": path.name, "fileSize": len(blob)},
        "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}}}})["data"]
    for op in shot["attributes"]["uploadOperations"]:
        part = blob[op["offset"] : op["offset"] + op["length"]]
        headers = {h["name"]: h["value"] for h in op.get("requestHeaders", [])}
        req = urllib.request.Request(op["url"], method=op["method"], data=part, headers=headers)
        urllib.request.urlopen(req, timeout=120).read()
    asc.call("PATCH", f"/v1/appScreenshots/{shot['id']}", {"data": {
        "type": "appScreenshots", "id": shot["id"],
        "attributes": {"uploaded": True, "sourceFileChecksum": hashlib.md5(blob).hexdigest()}}})
    return shot["id"]


def main():
    argv = sys.argv[1:]
    if not argv or argv[0].startswith("-"):
        raise SystemExit(__doc__)
    version = argv[0]
    apply = "--apply" in argv
    # {locale: {appStoreVersionLocalizations attribute: value}}
    meta = json.loads(pathlib.Path(argv[argv.index("--metadata") + 1]).read_text()) if "--metadata" in argv else {}
    meta = {k: v for k, v in meta.items() if not k.startswith("_")}
    locales = sorted(p.name for p in SHOTS.iterdir() if p.is_dir())
    if "--locales" in argv:
        locales = argv[argv.index("--locales") + 1].split(",")
    if not locales:
        raise SystemExit(f"no screenshots in {SHOTS} (run tool/appstore_captions.py)")

    asc = Asc()
    app = asc.data(f"/v1/apps?filter[bundleId]={BUNDLE_ID}")[0]["id"]
    vs = [v for v in asc.data(f"/v1/apps/{app}/appStoreVersions?filter[versionString]={version}&filter[platform]=IOS")]
    if not vs:
        raise SystemExit(f"App Store Connect has no version {version}: create it first (+ Version or Platform)")
    v = vs[0]
    print(f"{version}: {v['attributes']['appStoreState']}")
    have = {l["attributes"]["locale"]: l for l in asc.data(f"/v1/appStoreVersions/{v['id']}/appStoreVersionLocalizations?limit=50")}

    for locale in locales:
        loc = have.get(locale)
        if loc is None:
            print(f"{locale}: no localization on {version}" + ("; creating" if apply else ""))
            if not apply:
                continue
            loc = asc.call("POST", "/v1/appStoreVersionLocalizations", {"data": {
                "type": "appStoreVersionLocalizations", "attributes": {"locale": locale},
                "relationships": {"appStoreVersion": {"data": {"type": "appStoreVersions", "id": v["id"]}}}}})["data"]
        if locale in meta:
            for k, val in meta[locale].items():
                print(f"{locale}: {k} ← {val[:50]!r}")
            if apply:
                asc.call("PATCH", f"/v1/appStoreVersionLocalizations/{loc['id']}", {"data": {
                    "type": "appStoreVersionLocalizations", "id": loc["id"], "attributes": meta[locale]}})
        sets = {s["attributes"]["screenshotDisplayType"]: s for s in asc.data(f"/v1/appStoreVersionLocalizations/{loc['id']}/appScreenshotSets")}
        for target, display in DISPLAY.items():
            files = sorted((SHOTS / locale / target).glob("*.png"))
            if not files:
                continue
            old = asc.data(f"/v1/appScreenshotSets/{sets[display]['id']}/appScreenshots") if display in sets else []
            print(f"{locale}: {display} {len(old)} → {len(files)}")
            if not apply:
                continue
            if display not in sets:
                sets[display] = asc.call("POST", "/v1/appScreenshotSets", {"data": {
                    "type": "appScreenshotSets", "attributes": {"screenshotDisplayType": display},
                    "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": loc["id"]}}}}})["data"]
            for s in old:
                asc.call("DELETE", f"/v1/appScreenshots/{s['id']}")
            ids = [upload(asc, sets[display]["id"], f) for f in files]
            asc.call("PATCH", f"/v1/appScreenshotSets/{sets[display]['id']}/relationships/appScreenshots",
                     {"data": [{"type": "appScreenshots", "id": i} for i in ids]})
    if not apply:
        print("\n(read only; --apply to change)")


if __name__ == "__main__":
    main()
