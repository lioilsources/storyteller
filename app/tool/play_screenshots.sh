#!/bin/sh
# Google Play phone screenshots: the same integration test as
# tool/store_screenshots.sh, on a booted Android emulator, captured with
# adb each time the test prints `SHOT <name>`. The screen is switched to
# 1080x1920 (9:16, what Play features) for the run, the system language to
# Czech, and the status bar to demo mode (12:00, full battery, no icons).
#
#   tool/play_screenshots.sh [device] [out dir]
#
# Needs the packs and the model in assets/rag/ (see .github/workflows/release-android.yml).
set -eu
DEV="${1:-emulator-5554}"
OUT="${2:-../store/play/phone}"
cd "$(dirname "$0")/.."
mkdir -p "$OUT"
rm -f "$OUT"/*.png
A="adb -s $DEV"

$A shell cmd locale set-device-locale cs-CZ
$A shell wm size 1080x1920
$A shell settings put global sysui_demo_allowed 1
demo() { $A shell am broadcast -a com.android.systemui.demo -e command "$@" >/dev/null; }
demo enter
demo clock -e hhmm 1200
demo battery -e level 100 -e plugged false
demo network -e wifi show -e level 4 -e mobile show -e datatype none -e level 4
demo notifications -e visible false

flutter test integration_test/store_screenshots_test.dart -d "$DEV" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    case "$line" in
      *"SHOT "*)
        name="${line##*SHOT }"
        sleep 1
        $A exec-out screencap -p > "$OUT/$name.png"
        ;;
    esac
  done

demo exit
$A shell wm size reset
# Play wants 24-bit PNG, screencap gives RGBA.
python3 -c 'import sys; from PIL import Image; [Image.open(p).convert("RGB").save(p) for p in sys.argv[1:]]' "$OUT"/*.png
ls -1 "$OUT"
