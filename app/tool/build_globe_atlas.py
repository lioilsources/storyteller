#!/usr/bin/env python3
"""Sticker renders -> cut-out sprites -> one atlas for the globe.

    python3 app/tool/build_globe_atlas.py            # cut + pack
    python3 app/tool/build_globe_atlas.py --sheet    # also a contact sheet of every variant
    python3 app/tool/build_globe_atlas.py --install  # and copy the atlas into the app

Input: rag/data/globe_sprites/raw-<variant>/<id>.jpg, as rendered by
`render-motifs -style sticker -bg "navy blue"` (STORYTELLER_GLOBE_PLAN.md
§6). Which variant of an id is used comes from globe_picks.json next to this script
({"eiffel": "b"}); an id without a pick takes variant "a", and a pick of
"-" leaves the id out (no variant is usable — the globe keeps its
placeholder until a re-render).

Output, all under rag/data/globe_sprites/ (gitignored):
  cut/<id>.png            192 px, transparent background, trimmed and squared
  atlas/atlas.webp        every sprite on one sheet
  atlas/atlas.json        {"size": 192, "sprites": {id: [x, y, w, h]}}

The background is cut by flood-filling from the corners with a generous
tolerance (the sticker's white outline stops the fill), then whatever is
enclosed is keyed out at a tight one, so a navy roof inside the icon
survives. Needs ImageMagick (`magick`) and Pillow.
"""
import argparse
import json
import math
import shutil
import subprocess
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2] / "rag" / "data" / "globe_sprites"
SIZE = 192


def cut(src: Path, dst: Path) -> None:
    corner = subprocess.check_output(["magick", str(src), "-format", "%[pixel:p{4,4}]", "info:"], text=True)
    subprocess.check_call([
        "magick", str(src), "-alpha", "set",
        # A border in the background's own colour joins the four corners, so
        # one fill reaches all of it even when the icon touches an edge.
        "-bordercolor", corner, "-border", "2",
        "-fuzz", "22%", "-fill", "none", "-draw", "alpha 0,0 floodfill", "-shave", "2x2",
        # Background the fill can't reach — under the torii gate, through an
        # arch — goes by colour, but only at very nearly the corner's exact
        # shade, so a blue tower or a navy roof stays.
        "-fuzz", "7%", "-transparent", corner,
        # Pull the edge in a hair and soften it: no navy fringe on the outline.
        "-channel", "A", "-morphology", "Erode", "Disk:1.2", "-blur", "0x0.6", "+channel",
        "-trim", "+repage", "-bordercolor", "none", "-border", "12",
        # The rendered outline is a hairline once the sticker is 30 px on the
        # globe; a second, wider white rim under it keeps the icon off the land.
        "(", "+clone", "-alpha", "extract", "-morphology", "Dilate", "Disk:9", "-blur", "0x0.8",
        "-background", "white", "-alpha", "shape", ")", "+swap", "-background", "none", "-layers", "merge", "+repage",
        "-background", "none", "-gravity", "center",
        "-extent", "%[fx:max(w,h)]x%[fx:max(w,h)]", "-resize", f"{SIZE}x{SIZE}", str(dst),
    ])


def coverage(png: Path) -> float:
    """Share of the sprite that is opaque. Near 1 means the fill never got
    in (no clean background), near 0 that it ate the icon."""
    a = Image.open(png).convert("RGBA").getchannel("A")
    return sum(1 for v in a.tobytes() if v > 128) / (a.width * a.height)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sheet", action="store_true", help="write sheet.png: every variant of every id, for picking")
    ap.add_argument("--install", action="store_true", help="copy the atlas into app/assets/globe/, where the app bundles it")
    args = ap.parse_args()

    variants = sorted(p.name[4:] for p in ROOT.glob("raw-*") if p.is_dir())
    if not variants:
        print(f"no raw-* directories under {ROOT}", file=sys.stderr)
        return 1
    picks_file = Path(__file__).with_name("globe_picks.json")  # tracked: the renders are not, the choice is
    picks = json.loads(picks_file.read_text()) if picks_file.exists() else {}
    ids = sorted({p.stem for v in variants for p in (ROOT / f"raw-{v}").glob("*.jpg")})
    every = ids
    ids = [i for i in ids if picks.get(i) != "-"]

    if args.sheet:
        tile, bg = 160, (129, 199, 132, 255)  # the globe's covered-land green
        sheet = Image.new("RGBA", (tile * len(variants), tile * len(every)), bg)
        tmp = ROOT / "sheet-cut"
        tmp.mkdir(exist_ok=True)
        for row, i in enumerate(every):
            for col, v in enumerate(variants):
                src = ROOT / f"raw-{v}" / f"{i}.jpg"
                if not src.exists():
                    continue
                dst = tmp / f"{i}.{v}.png"
                if not dst.exists():
                    cut(src, dst)
                im = Image.open(dst).convert("RGBA").resize((tile - 8, tile - 8))
                sheet.alpha_composite(im, (col * tile + 4, row * tile + 4))
        sheet.convert("RGB").save(ROOT / "sheet.png")
        print(f"sheet.png: {len(ids)} rows ({', '.join(ids[:3])}, …) × variants {variants}")

    (ROOT / "cut").mkdir(exist_ok=True)
    (ROOT / "atlas").mkdir(exist_ok=True)
    suspicious = []
    for i in ids:
        v = picks.get(i, variants[0])
        src = ROOT / f"raw-{v}" / f"{i}.jpg"
        if not src.exists():
            print(f"{i}: no variant {v}", file=sys.stderr)
            return 1
        dst = ROOT / "cut" / f"{i}.png"
        cut(src, dst)
        c = coverage(dst)
        if not 0.08 < c < 0.92:
            suspicious.append(f"{i} ({v}): {c:.0%} opaque")

    cols = math.ceil(math.sqrt(len(ids)))
    rows = math.ceil(len(ids) / cols)
    atlas = Image.new("RGBA", (cols * SIZE, rows * SIZE), (0, 0, 0, 0))
    rects = {}
    for n, i in enumerate(ids):
        x, y = (n % cols) * SIZE, (n // cols) * SIZE
        atlas.alpha_composite(Image.open(ROOT / "cut" / f"{i}.png").convert("RGBA"), (x, y))
        rects[i] = [x, y, SIZE, SIZE]
    atlas.save(ROOT / "atlas" / "atlas.webp", quality=85, method=6)
    (ROOT / "atlas" / "atlas.json").write_text(json.dumps({"size": SIZE, "sprites": rects}, separators=(",", ":")))
    kb = (ROOT / "atlas" / "atlas.webp").stat().st_size / 1024
    print(f"atlas: {len(ids)} sprites, {atlas.width}×{atlas.height}, {kb:.0f} KB")
    for s in suspicious:
        print(f"  check the cut-out: {s}")
    if args.install:
        dest = Path(__file__).resolve().parents[1] / "assets" / "globe"
        dest.mkdir(exist_ok=True)
        for name in ("atlas.webp", "atlas.json"):
            shutil.copyfile(ROOT / "atlas" / name, dest / name)
        print(f"installed into {dest}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
