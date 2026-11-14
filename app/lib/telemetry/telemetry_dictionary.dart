import 'package:ol1n_telemetry/ol1n_telemetry.dart';

/// The app version this build reports; `test/telemetry_test.dart` keeps it
/// equal to `version:` in `pubspec.yaml` (no package_info, plan §3).
const kAppVersion = '1.8.1';

/// The app id in StoreMetrics `apps.yaml`.
const kTelemetryApp = 'pohadkomat';

/// go_router route → screen. go_router names a page `state.name ??
/// state.path`, and no route here has a name, so the keys are the route
/// paths (checked in `test/telemetry_test.dart`). Unmapped routes report
/// `other`.
const kScreenRoutes = {
  '/globe': 'globe',
  '/cast': 'cast',
  '/task': 'task',
  '/problem': 'problem',
  '/ending': 'ending',
  '/osnova': 'osnova',
  '/vypravim': 'narrate',
};

/// Region codes of `manifest.v4.json` (PACKS_V2 §1). A region the manifest
/// adds later reports `other` until the dictionary learns it.
const kRegions = {
  'czsk', 'dach', 'brit', 'frbx', 'iber', 'medi', 'nord', 'east', //
  'indi', 'easi', 'seao', 'meas', 'afri', 'namc', 'same',
};

/// [code] (the manifest's `CZSK`, …) as a dictionary value: a known region
/// code in lower case, else `other`.
String telemetryRegion(String? code) {
  final c = code?.toLowerCase();
  return kRegions.contains(c) ? c! : 'other';
}

const _region = EnumProp({...kRegions, 'other'});
const _beat = EnumProp({'cast', 'task', 'problem', 'ending'});

/// The one event dictionary of Pohádkomat, mirrored in `docs/telemetry.md`.
/// Only enums, counts and yes/no: nothing about the story, the cast, what
/// the parent types or says, or the child.
final appDictionary = TelemetryDictionary(
  appVersion: kAppVersion,
  languages: {'cs'},
  screens: kScreenRoutes.values.toSet(),
  features: {
    'globe_spin',
    'landmark_tap',
    'cast_reroll',
    'cast_resize',
    'motif_shuffle',
    'hint',
    'situation',
    'music',
    'sound_effect',
    'storage',
  },
  errorKinds: {'globe_load', 'offline', 'download', 'purchase', 'restore', 'hint'},
  lockedTargets: {'country_empty'},
  events: {
    ...TelemetryDictionary.flow(
      'compose',
      start: {'region': _region},
      end: {
        'step': const EnumProp({'cast', 'task', 'problem', 'ending', 'osnova'}),
        'cast': const IntProp(6),
      },
    ),
    ...TelemetryDictionary.flow(
      'narrate',
      start: {'source': const EnumProp({'pack', 'curated'})},
      end: {
        'beat': const IntProp(4),
        'hints': const IntProp(1000),
        'sounds': const IntProp(10000),
      },
    ),
    'hint_show': {
      'beat': _beat,
      'source': const EnumProp({'pack', 'template', 'fallback'}),
    },
    ...TelemetryDictionary.flow(
      'download',
      results: {'offline'},
      start: {
        'kind': const EnumProp({'region_free', 'part', 'scenes'}),
        'region': _region,
      },
    ),
    ...TelemetryDictionary.flow(
      'purchase',
      results: {'pending'},
      start: {'region': _region},
    ),
    'purchase_restore': {
      'result': const EnumProp({'ok', 'none', 'error'}),
      'parts': const IntProp(1000),
    },
  },
);
