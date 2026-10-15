#!/usr/bin/env python3
"""Check every store text in app_review_metadata.md against its field limit.

A field is a "### Name (N)" or "### Name (N, …)" heading; its text is the
first fenced block that follows.
"""
import pathlib
import re
import sys

lines = (pathlib.Path(__file__).parent / "app_review_metadata.md").read_text().splitlines()
bad = False
field = None
body = None
for line in lines:
    head = re.match(r"### (.+?) \((\d+)", line)
    if head:
        field, body = (head.group(1), int(head.group(2))), None
    elif line.startswith("#"):
        field = None
    elif field and line == "```":
        if body is None:
            body = []
            continue
        n = len("\n".join(body))
        ok = n <= field[1]
        bad |= not ok
        print(f"{'ok  ' if ok else 'OVER'} {n:>4}/{field[1]:<4} {field[0]}")
        field, body = None, None
    elif field and body is not None:
        body.append(line)
sys.exit(1 if bad else 0)
