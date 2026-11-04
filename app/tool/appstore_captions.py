#!/usr/bin/env python3
"""Localized App Store screenshots: a caption over each raw capture.

    python3 tool/appstore_captions.py [--src DIR] [--locales cs,en-US] [--targets iphone-6.9]

Input:  build/store_screenshots/*.png       (tool/store_screenshots.sh)
        ../store/appstore_captions.json     (caption per locale and shot)
Output: build/appstore_screenshots/<locale>/<target>/NN_<name>.png
        build/appstore_screenshots/preview.png   (every locale, iPhone, side by side)

The app itself is Czech only, so every locale shows the same Czech screens;
the caption sells the step in the buyer's language and the first shot says
under its caption that the app is in Czech for now (`note`).

Output goes to build/ (14 locales x 2 sizes x 7 shots, ~200 MB): it is
regenerated, not committed. Upload with tool/appstore_upload_shots.py.
"""
import json
import pathlib
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

from appstore_shots import flatten

APP = pathlib.Path(__file__).resolve().parent.parent
DEFAULT_SRC = APP / "build" / "store_screenshots"
CAPTIONS = APP.parent / "store" / "appstore_captions.json"
OUT_DIR = APP / "build" / "appstore_screenshots"

# What App Store Connect has slots for (the 6.3" slot is filled from 6.9").
TARGETS = {
    "iphone-6.9": (1290, 2796),
    "ipad-13": (2064, 2752),
}

BG = (255, 251, 242)  # the app's cream
INK = (162, 62, 34)  # the app's title rust
FILL = (255, 228, 212)  # the app's title fill
NOTE = (122, 86, 70)


def _font_dir() -> pathlib.Path:
    """The CuteKidFonts checkout pub resolved for this app."""
    config = json.loads((APP / ".dart_tool" / "package_config.json").read_text())
    root = next(p["rootUri"] for p in config["packages"] if p["name"] == "cute_kid_fonts")
    return pathlib.Path(root.removeprefix("file://")) / "fonts"


FONTS = _font_dir()
# The app's title face first; the rest only where it has no glyphs
# (DynaPuff: no Vietnamese; Japanese and Korean need system CJK faces).
CANDIDATES = [
    (FONTS / "DynaPuff-Variable.ttf", 0, "Bold"),
    (FONTS / "Baloo2-Variable.ttf", 0, "ExtraBold"),
    (FONTS / "Nunito-Variable.ttf", 0, "Black"),
    (pathlib.Path("/System/Library/Fonts/ヒラギノ丸ゴ ProN W4.ttc"), 0, None),
    (pathlib.Path("/System/Library/Fonts/AppleSDGothicNeo.ttc"), 6, None),  # Bold
]


def _load(spec, size):
    path, index, style = spec
    font = ImageFont.truetype(str(path), size, index=index)
    if style:
        font.set_variation_by_name(style)
    return font


def _covers(font, text) -> bool:
    """True when the font draws every character of text (no .notdef box)."""
    def glyph(ch):
        im = Image.new("L", (font.size * 2, font.size * 2))
        ImageDraw.Draw(im).text((0, 0), ch, font=font, fill=255)
        return im.tobytes()

    missing = glyph("\U0010fffd")
    return all(ch.isspace() or glyph(ch) != missing for ch in set(text))


def font_for(text, size):
    for spec in CANDIDATES:
        font = _load(spec, size)
        if _covers(font, text):
            return font
    raise SystemExit(f"no font covers {text!r}")


def wrap(draw, text, font, width):
    """Greedy word wrap; CJK without spaces breaks between characters."""
    tokens = text.split(" ") if " " in text else list(text)
    sep = " " if " " in text else ""
    lines, line = [], ""
    for tok in tokens:
        cand = f"{line}{sep}{tok}" if line else tok
        if draw.textlength(cand, font=font) <= width or not line:
            line = cand
        else:
            lines.append(line)
            line = tok
    lines.append(line)
    return lines


def caption_block(draw, text, size, max_w, max_lines=2):
    """Font and lines for text, shrinking the size until it fits."""
    while True:
        font = font_for(text, size)
        lines = wrap(draw, text, font, max_w)
        if len(lines) <= max_lines or size < 40:
            return font, lines
        size = round(size * 0.92)


def render(shot: Image.Image, size, caption: str, note: str | None) -> Image.Image:
    W, H = size
    canvas = Image.new("RGB", size, BG)
    draw = ImageDraw.Draw(canvas)

    top = round(H * 0.035)
    cap_size = round(min(W * 0.078, H * 0.046))
    font, lines = caption_block(draw, caption, cap_size, W * 0.88)
    stroke = max(4, round(font.size * 0.09))
    line_h = round(font.size * 1.18)
    y = top
    for line in lines:
        draw.text((W / 2, y), line, font=font, fill=FILL, anchor="mt", stroke_width=stroke, stroke_fill=INK)
        y += line_h
    if note:
        nfont = font_for(note, round(font.size * 0.42))
        draw.text((W / 2, y + round(font.size * 0.1)), note, font=nfont, fill=NOTE, anchor="mt")
    # The caption band is the same height on every shot, one or two lines,
    # so the screens line up when the store shows them side by side.
    band = top + 2 * round(cap_size * 1.18) + round(cap_size * 0.75)

    avail_h = H - band - round(H * 0.03)
    scale = min(avail_h / shot.height, W * 0.86 / shot.width)
    s = shot.resize((round(shot.width * scale), round(shot.height * scale)), Image.LANCZOS)
    radius = round(s.width * 0.06)
    mask = Image.new("L", s.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, s.width - 1, s.height - 1], radius=radius, fill=255)
    pos = ((W - s.width) // 2, band)

    shadow = Image.new("RGBA", size, (0, 0, 0, 0))
    blur = round(W * 0.02)
    shadow.paste((62, 39, 35, 60), (pos[0], pos[1] + blur // 2), mask)
    shadow = shadow.filter(ImageFilter.GaussianBlur(blur))
    canvas.paste(shadow, (0, 0), shadow)
    # A thin rust edge, so the cream screen does not melt into the cream page.
    edge = Image.new("L", (s.width + 6, s.height + 6), 0)
    ImageDraw.Draw(edge).rounded_rectangle([0, 0, s.width + 5, s.height + 5], radius=radius + 3, fill=255)
    canvas.paste(INK, (pos[0] - 3, pos[1] - 3), edge)
    canvas.paste(s, pos, mask)
    return canvas


def main():
    argv = sys.argv[1:]

    def arg(name, default=None):
        return argv[argv.index(name) + 1] if name in argv else default

    src = pathlib.Path(arg("--src", DEFAULT_SRC))
    captions = {k: v for k, v in json.loads(CAPTIONS.read_text()).items() if not k.startswith("_")}
    locales = arg("--locales", ",".join(captions)).split(",")
    targets = {n: TARGETS[n] for n in arg("--targets", ",".join(TARGETS)).split(",")}

    shots = sorted(src.glob("*.png"))
    if not shots:
        raise SystemExit(f"no screenshots in {src}")
    for locale in locales:
        texts = captions[locale]
        for path in shots:
            if path.stem not in texts:
                raise SystemExit(f"{locale}: no caption for {path.stem}")

    previews = []
    for locale in locales:
        texts = captions[locale]
        for name, size in targets.items():
            out = OUT_DIR / locale / name
            out.mkdir(parents=True, exist_ok=True)
            for old in out.glob("*.png"):
                old.unlink()
            row = []
            for i, path in enumerate(shots):
                note = texts.get("note") if i == 0 else None
                im = render(flatten(Image.open(path)), size, texts[path.stem], note)
                im.save(out / path.name, "PNG")
                if name == "iphone-6.9":
                    row.append(im.resize((size[0] // 6, size[1] // 6), Image.LANCZOS))
            print(f"{locale:<6} {name:<11} {len(shots)} shots")
            if row:
                previews.append(row)

    if previews:
        w, h = previews[0][0].size
        sheet = Image.new("RGB", (len(previews[0]) * (w + 8), len(previews) * (h + 8)), "white")
        for r, row in enumerate(previews):
            for c, im in enumerate(row):
                sheet.paste(im, (c * (w + 8), r * (h + 8)))
        sheet.save(OUT_DIR / "preview.png")
        print(f"preview → {OUT_DIR / 'preview.png'}")


if __name__ == "__main__":
    main()
