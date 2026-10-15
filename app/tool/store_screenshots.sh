#!/bin/sh
# Raw store screenshots: runs integration_test/store_screenshots_test.dart on
# a booted simulator and captures the screen each time the test prints
# `SHOT <name>`. Czech system language, status bar at 9:41 / full battery.
#
#   tool/store_screenshots.sh [simulator] [out dir]
#
# Needs the packs and the model in assets/rag/ (see .github/workflows/release-ios.yml).
# The raw PNGs then go through tool/appstore_shots.py.
set -eu
SIM="${1:-Pohadkomat-iPhone}"
OUT="${2:-build/store_screenshots}"
cd "$(dirname "$0")/.."
mkdir -p "$OUT"
rm -f "$OUT"/*.png

xcrun simctl status_bar "$SIM" override --time 9:41 \
  --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
xcrun simctl spawn "$SIM" defaults write -g AppleLanguages -array cs
xcrun simctl spawn "$SIM" defaults write -g AppleLocale cs_CZ

flutter test integration_test/store_screenshots_test.dart -d "$SIM" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    case "$line" in
      *"SHOT "*)
        name="${line##*SHOT }"
        sleep 1
        xcrun simctl io "$SIM" screenshot "$OUT/$name.png" >/dev/null 2>&1
        ;;
    esac
  done

xcrun simctl status_bar "$SIM" clear
ls -1 "$OUT"
