#!/usr/bin/env python3
"""Validate app/assets/geo/landmarks.json against countries.json.

Usage: python3 app/tool/check_landmarks.py
Prints every violation and exits 1, or prints OK and exits 0.
"""
import json
import math
import os
import re
import sys

GEO = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'assets', 'geo')
KEYS = {'id': str, 'iso': str, 'n': str, 'en': str, 'o': (int, float),
        'a': (int, float), 's': str, 'p': int}
MIN_SEP = 0.8        # degrees, same-country landmarks
ANTI_MAX = 12.0      # degrees from true location for antimeridian countries
# True locations (lon, lat) for landmarks of countries whose rings span the
# antimeridian, where raw ray casting is unreliable.
ANTI_TRUE = {
    'polar-station': (-57.88, -63.80),  # Mendel Polar Station, James Ross Island
}


def in_ring(x, y, ring):
    inside = False
    n = len(ring) // 2
    j = n - 1
    for i in range(n):
        xi, yi = ring[2 * i], ring[2 * i + 1]
        xj, yj = ring[2 * j], ring[2 * j + 1]
        if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi:
            inside = not inside
        j = i
    return inside


def crosses_antimeridian(country):
    return any(max(r[0::2]) - min(r[0::2]) > 180 for r in country['p'])


def main():
    errs = []
    countries = {c['i']: c for c in json.load(open(os.path.join(GEO, 'countries.json'), encoding='utf-8'))}
    try:
        items = json.load(open(os.path.join(GEO, 'landmarks.json'), encoding='utf-8'))
    except Exception as e:  # noqa: BLE001
        print('landmarks.json unreadable: %s' % e)
        return 1
    if not isinstance(items, list):
        print('landmarks.json: top level must be a list')
        return 1

    seen = set()
    by_iso = {}
    for idx, it in enumerate(items):
        tag = '#%d %s' % (idx, it.get('id') if isinstance(it, dict) else '?')
        if not isinstance(it, dict):
            errs.append('%s: not an object' % tag)
            continue
        bad = False
        for k, t in KEYS.items():
            if k not in it or isinstance(it[k], bool) or not isinstance(it[k], t):
                errs.append('%s: missing/invalid key "%s"' % (tag, k))
                bad = True
        for k in it:
            if k not in KEYS:
                errs.append('%s: unknown key "%s"' % (tag, k))
        if bad:
            continue
        if not re.fullmatch(r'[a-z0-9]+(-[a-z0-9]+)*', it['id']):
            errs.append('%s: id is not kebab-case ASCII' % tag)
        if it['id'] in seen:
            errs.append('%s: duplicate id' % tag)
        seen.add(it['id'])
        if it['s'] != it['id']:
            errs.append('%s: s != id' % tag)
        if not it['n'].strip() or not it['en'].strip():
            errs.append('%s: empty name' % tag)
        if not 1 <= it['p'] <= 3:
            errs.append('%s: p=%r not in 1..3' % (tag, it['p']))
        if not (-180 <= it['o'] <= 180 and -90 <= it['a'] <= 90):
            errs.append('%s: coordinates out of range' % tag)
        c = countries.get(it['iso'])
        if c is None:
            errs.append('%s: unknown iso "%s"' % (tag, it['iso']))
            continue
        by_iso.setdefault(it['iso'], []).append(it)
        if crosses_antimeridian(c):
            true = ANTI_TRUE.get(it['id'])
            if true is None:
                errs.append('%s: antimeridian country %s needs an ANTI_TRUE entry' % (tag, it['iso']))
            else:
                dlon = abs(it['o'] - true[0])
                dlon = min(dlon, 360 - dlon)
                if math.hypot(dlon, it['a'] - true[1]) > ANTI_MAX:
                    errs.append('%s: more than %g deg from true location' % (tag, ANTI_MAX))
        elif not any(in_ring(it['o'], it['a'], r) for r in c['p']):
            errs.append('%s: anchor (%s, %s) outside %s polygons' % (tag, it['o'], it['a'], it['iso']))

    for iso, c in countries.items():
        lst = by_iso.get(iso, [])
        if not lst:
            errs.append('%s (%s): no landmark' % (iso, c['n']))
            continue
        top = max(l['p'] for l in lst)
        if sum(1 for l in lst if l['p'] == top) != 1:
            errs.append('%s: %d landmarks share top priority %d' % (
                iso, sum(1 for l in lst if l['p'] == top), top))
        for i in range(len(lst)):
            for j in range(i + 1, len(lst)):
                d = math.hypot(lst[i]['o'] - lst[j]['o'], lst[i]['a'] - lst[j]['a'])
                if d < MIN_SEP:
                    errs.append('%s: %s and %s only %.2f deg apart' % (
                        iso, lst[i]['id'], lst[j]['id'], d))

    order = [(it.get('iso', ''), -it.get('p', 0)) for it in items if isinstance(it, dict)]
    if order != sorted(order):
        errs.append('not sorted by iso, then priority descending')

    if errs:
        print('\n'.join(errs))
        print('%d violation(s)' % len(errs))
        return 1
    n = {p: sum(1 for it in items if it['p'] == p) for p in (3, 2, 1)}
    print('OK: %d landmarks, %d countries (p3=%d p2=%d p1=%d)' % (
        len(items), len(by_iso), n[3], n[2], n[1]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
