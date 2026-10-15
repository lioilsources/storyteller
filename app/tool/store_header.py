#!/usr/bin/env python3
"""Render the App Store product page header and search results artwork.

    python3 tool/store_header.py

  ../store/appstore_creative/header-3840x1646.png   product page header (21:9)
  ../store/appstore_creative/search-3840x2560.png   search results asset (3:2)

A table strewn with scene illustrations from the bundled packs, one row per
few regions, with three character cards of one tale in the middle. No text
at all, so one image serves every localization.

Apple publishes the sizes but not how each device crops them. The header
template marks a 1646x661 "Art Safe Area" in the centre of the 3840x1646
canvas; the hero cards sit inside it and the wall may be cut anywhere. Check
the result with Preview in App Store Connect before submitting.

Needs the packs in assets/rag/packs/ (see .github/workflows/release-ios.yml).
"""
import colorsys
import glob
import io
import pathlib
import random
import sqlite3

from PIL import Image, ImageDraw, ImageFilter, ImageStat

APP = pathlib.Path(__file__).resolve().parent.parent
PACKS = APP / "assets" / "rag" / "packs"
OUT = APP.parent / "store" / "appstore_creative"

BG = (250, 232, 214)
INK = (62, 39, 35)
# The tale the store screenshots tell (integration_test/store_screenshots_test.dart).
HEROES = ["Liška Ryška", "Královic", "Pták Ohnivák"]
PER_PACK = 6


def lively(im):
    """Bright and colourful enough to sit on a wall: dark or washed-out
    scenes make muddy tiles at this size."""
    small = im.resize((32, 32))
    r, g, b = [v / 255 for v in ImageStat.Stat(small).mean]
    _, light, _ = colorsys.rgb_to_hls(r, g, b)
    sat = sum(colorsys.rgb_to_hsv(*[c / 255 for c in px])[1] for px in small.getdata()) / 1024
    return 0.45 < light < 0.8 and sat > 0.28


def scenes():
    out = []
    for path in sorted(glob.glob(str(PACKS / "region.*.db"))):
        db = sqlite3.connect(path)
        taken = 0
        for (jpeg,) in db.execute("SELECT jpeg FROM scene_images ORDER BY scene_id"):
            im = Image.open(io.BytesIO(jpeg)).convert("RGB")
            if lively(im):
                out.append(im)
                taken += 1
                if taken == PER_PACK:
                    break
    return out


def heroes():
    db = sqlite3.connect(PACKS / "region.CZSK.cs.free.db")
    out = []
    for title in HEROES:
        row = db.execute(
            "SELECT i.jpeg FROM motifs m JOIN motif_images i ON i.motif_id = m.id "
            "JOIN verbalizations v ON v.motif_id = m.id AND v.length = 'title' AND v.lang = 'cs' "
            "WHERE m.type = 'character' AND v.text = ? ORDER BY m.id LIMIT 1", (title,)).fetchone()
        out.append(Image.open(io.BytesIO(row[0])).convert("RGB"))
    return out


def card(im, side, angle):
    """A white-bordered rounded card with a soft shadow, rotated."""
    border = round(side * 0.045)
    radius = round(side * 0.09)
    inner = im.resize((side - 2 * border, side - 2 * border), Image.LANCZOS)
    face = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    ImageDraw.Draw(face).rounded_rectangle([0, 0, side - 1, side - 1], radius=radius, fill=(255, 253, 248, 255))
    mask = Image.new("L", inner.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, inner.width - 1, inner.height - 1], radius=radius - border, fill=255)
    face.paste(inner, (border, border), mask)

    pad = round(side * 0.2)
    tile = Image.new("RGBA", (side + 2 * pad, side + 2 * pad), (0, 0, 0, 0))
    shadow = Image.new("RGBA", tile.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [pad, pad + round(side * 0.03), pad + side, pad + side + round(side * 0.03)], radius=radius, fill=INK + (90,))
    tile.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(round(side * 0.04))))
    tile.alpha_composite(face, (pad, pad))
    return tile.rotate(angle, resample=Image.BICUBIC, expand=True)


def render(size, rows, hero_side, name):
    w, h = size
    rng = random.Random(7)
    pool = scenes()
    rng.shuffle(pool)
    canvas = Image.new("RGBA", size, BG + (255,))

    step = h / rows
    side = round(step * 1.02)
    cols = int(w / step) + 2
    n = 0
    for r in range(rows):
        for c in range(cols):
            x = (c - 0.5) * step + (step / 2 if r % 2 else 0) + rng.uniform(-0.06, 0.06) * step
            y = (r + 0.5) * step + rng.uniform(-0.05, 0.05) * step
            tile = card(pool[n % len(pool)], side, rng.uniform(-7, 7))
            n += 1
            canvas.alpha_composite(tile, (round(x - tile.width / 2), round(y - tile.height / 2)))

    # A cream glow so the heroes read against the wall.
    glow = Image.new("RGBA", size, (0, 0, 0, 0))
    gw, gh = hero_side * 2.3, hero_side * 0.85
    ImageDraw.Draw(glow).ellipse([w / 2 - gw, h / 2 - gh, w / 2 + gw, h / 2 + gh], fill=BG + (235,))
    canvas.alpha_composite(glow.filter(ImageFilter.GaussianBlur(hero_side * 0.22)))

    for i, (im, angle) in enumerate(zip(heroes(), (-6, 0, 6))):
        tile = card(im, hero_side, angle)
        x = w / 2 + (i - 1) * hero_side * 1.08
        y = h / 2 + (0 if i == 1 else hero_side * 0.04)
        canvas.alpha_composite(tile, (round(x - tile.width / 2), round(y - tile.height / 2)))

    OUT.mkdir(parents=True, exist_ok=True)
    dest = OUT / name
    canvas.convert("RGB").save(dest, "PNG")  # no alpha: App Store Connect rejects it
    print(dest.name, size)


if __name__ == "__main__":
    # Heroes span ~1500 px, inside the header's 1646x661 safe area.
    render((3840, 1646), rows=3, hero_side=480, name="header-3840x1646.png")
    render((3840, 2560), rows=4, hero_side=760, name="search-3840x2560.png")
