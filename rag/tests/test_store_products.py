import base64
import json
import subprocess

from rag import regions, store_products as sp


def _state(parts: dict[str, int]) -> dict:
    return {"lang": "cs", "regions": {k: {"free": {"tales": []}, "queue": [], "parts": [{"tales": [f"{k}:{n}:{i}" for i in range(50)]} for n in range(1, count + 1)]} for k, count in parts.items()}}


def test_a_product_per_frozen_part_in_app_order():
    rs = sp.rows(_state({"EAST": 1, "CZSK": 2}))
    assert [r["product_id"] for r in rs] == ["pack_czsk_1", "pack_czsk_2", "pack_east_1"]
    assert rs[0]["name_cs"] == "Česko a Slovensko 1"
    assert rs[0]["description_cs"] == "50 pohádek k vyprávění, díl 1"
    assert rs[2]["name_en"] == "Eastern Europe 1"


def test_every_region_name_fits_app_store_connect_up_to_part_nine():
    rs = sp.rows(_state({k: 9 for k in regions.ORDER}))
    assert all(len(r["name_cs"]) <= sp.NAME_MAX and len(r["name_en"]) <= sp.NAME_MAX for r in rs)


def test_product_ids_match_the_manifest():
    # rag.region_packs writes product_id into manifest parts; the store must sell the same id.
    from rag import region_packs
    src = open(region_packs.__file__).read()
    assert 'f"pack_{low}_{n}"' in src
    assert sp.product_id("CZSK", 3) == "pack_czsk_3"


def test_asc_token_is_a_valid_es256_jwt(tmp_path):
    key = tmp_path / "AuthKey_TEST.p8"
    subprocess.run(["openssl", "ecparam", "-name", "prime256v1", "-genkey", "-noout", "-out", str(tmp_path / "ec.pem")], check=True)
    subprocess.run(["openssl", "pkcs8", "-topk8", "-nocrypt", "-in", str(tmp_path / "ec.pem"), "-out", str(key)], check=True)
    token = sp.asc_token("KEY123", "issuer-uuid", str(key), now=1_761_300_000)
    head, body, sig = token.split(".")
    pad = lambda s: s + "=" * (-len(s) % 4)  # noqa: E731
    assert json.loads(base64.urlsafe_b64decode(pad(head))) == {"alg": "ES256", "kid": "KEY123", "typ": "JWT"}
    claims = json.loads(base64.urlsafe_b64decode(pad(body)))
    assert claims["aud"] == "appstoreconnect-v1" and claims["exp"] - claims["iat"] <= 20 * 60
    raw = base64.urlsafe_b64decode(pad(sig))
    assert len(raw) == 64
    # back to DER and let openssl check it against the public key
    def der_int(b: bytes) -> bytes:
        b = b.lstrip(b"\0") or b"\0"
        if b[0] & 0x80:
            b = b"\0" + b
        return bytes([2, len(b)]) + b
    seq = der_int(raw[:32]) + der_int(raw[32:])
    (tmp_path / "sig.der").write_bytes(bytes([0x30, len(seq)]) + seq)
    subprocess.run(["openssl", "ec", "-in", str(key), "-pubout", "-out", str(tmp_path / "pub.pem")], check=True, capture_output=True)
    ok = subprocess.run(["openssl", "dgst", "-sha256", "-verify", str(tmp_path / "pub.pem"), "-signature", str(tmp_path / "sig.der")], input=f"{head}.{body}".encode(), capture_output=True)
    assert ok.returncode == 0, ok.stdout + ok.stderr


def test_every_part_costs_the_same():
    assert sp.PRICE_USD == "0.99"
