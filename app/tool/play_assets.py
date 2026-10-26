#!/usr/bin/env python3
"""Render the Google Play store listing graphics.

    python3 tool/play_assets.py

  ../store/play/icon-512.png               app icon, 512x512
  ../store/play/feature-1024x500.png       feature graphic

The feature graphic is the App Store header wall (tool/store_header.py) at
Play's size, no text. Play may crop its edges, so the heroes stay centred.
Phone screenshots come from an Android emulator: tool/play_screenshots.sh.

Needs the packs in assets/rag/packs/ for the feature graphic.
"""
import pathlib

from PIL import Image

import store_header

APP = pathlib.Path(__file__).resolve().parent.parent
OUT = APP.parent / "store" / "play"


def main():
    OUT.mkdir(parents=True, exist_ok=True)

    icon = Image.open(APP / "assets" / "icon" / "app_icon.png").convert("RGB")
    icon.resize((512, 512), Image.LANCZOS).save(OUT / "icon-512.png", "PNG")
    print("icon-512.png")

    store_header.OUT = OUT
    store_header.render((1024, 500), rows=2, hero_side=200, name="feature-1024x500.png")


if __name__ == "__main__":
    main()
