#!/usr/bin/env python3
"""Turn raw simulator screenshots into App Store Connect upload sets.

    python3 tool/appstore_shots.py [--src DIR] [--targets iphone-6.9,ipad-13]

Input:  build/store_screenshots/*.png  (tool/store_screenshots.sh, 1320x2868)
Output: ../store/appstore_screenshots/<size>/NN_<name>.png

Two fitting strategies, picked per target:

  cover  — the target's aspect matches the capture (both 19.5:9), so scale
           and trim the few leftover pixels.
  frame  — iPad is 3:4 against a 19.5:9 capture; cropping would throw away
           most of the screen, so the capture is centred at full height on
           the app's cream background.

Output is RGB without alpha: App Store Connect rejects an alpha channel.
"""
import pathlib
import sys

from PIL import Image, ImageDraw, ImageFilter

APP = pathlib.Path(__file__).resolve().parent.parent
DEFAULT_SRC = APP / "build" / "store_screenshots"
OUT_DIR = APP.parent / "store" / "appstore_screenshots"

# iPhone 6.9" is mandatory; iPad 13" too, because the Xcode target declares
# TARGETED_DEVICE_FAMILY "1,2".
TARGETS = {
    "iphone-6.9": ((1290, 2796), "cover"),
    # The "iPhone with Dynamic Island (medium display)" slot (6.1" / 6.3")
    # takes 1206x2622 or 1179x2556 and nothing larger.
    "iphone-6.3": ((1206, 2622), "cover"),
    "ipad-13": ((2064, 2752), "frame"),
}

FRAME_BG = (250, 232, 214)  # peach, a shade deeper than the app's cream


def flatten(im):
    if im.mode != "RGBA":
        return im.convert("RGB")
    bg = Image.new("RGB", im.size, (255, 255, 255))
    bg.paste(im, (0, 0), im)
    return bg


def cover(im, size):
    tw, th = size
    scale = max(tw / im.width, th / im.height)
    scaled = im.resize((round(im.width * scale), round(im.height * scale)), Image.LANCZOS)
    left = (scaled.width - tw) // 2
    top = (scaled.height - th) // 2
    return scaled.crop((left, top, left + tw, top + th))


def frame(im, size):
    tw, th = size
    margin = round(th * 0.06)
    scale = (th - 2 * margin) / im.height
    shot = im.resize((round(im.width * scale), round(im.height * scale)), Image.LANCZOS)

    radius = round(shot.width * 0.045)
    mask = Image.new("L", shot.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, shot.width - 1, shot.height - 1], radius=radius, fill=255)

    canvas = Image.new("RGB", size, FRAME_BG)
    pos = ((tw - shot.width) // 2, (th - shot.height) // 2)

    shadow = Image.new("RGBA", size, (0, 0, 0, 0))
    shadow.paste((62, 39, 35, 70), (pos[0], pos[1] + round(margin * 0.35)), mask)
    shadow = shadow.filter(ImageFilter.GaussianBlur(round(margin * 0.5)))
    canvas.paste(shadow, (0, 0), shadow)

    canvas.paste(shot, pos, mask)
    return canvas


def main():
    argv = sys.argv[1:]
    src = pathlib.Path(argv[argv.index("--src") + 1]) if "--src" in argv else DEFAULT_SRC
    targets = dict(TARGETS)
    if "--targets" in argv:
        targets = {n: TARGETS[n] for n in argv[argv.index("--targets") + 1].split(",")}

    # The capture names already carry their order (01_globe, 02_…).
    shots = sorted(src.glob("*.png"))
    if not shots:
        raise SystemExit(f"no screenshots in {src}")

    for name, (size, mode) in targets.items():
        out = OUT_DIR / name
        out.mkdir(parents=True, exist_ok=True)
        # Drop the old set so no stale file is left to be uploaded by mistake.
        for old in out.glob("*.png"):
            old.unlink()
        for path in shots:
            im = flatten(Image.open(path))
            result = cover(im, size) if mode == "cover" else frame(im, size)
            dest = out / path.name
            result.save(dest, "PNG")
            print(f"{name:<12} {size[0]}x{size[1]}  {dest.name}")


if __name__ == "__main__":
    main()
