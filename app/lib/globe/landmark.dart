import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A famous building the globe draws as an icon, so a child recognises
/// the country before they can read its name (STORYTELLER_GLOBE_PLAN.md
/// §2.1). Hand-authored in `assets/geo/landmarks.json`, checked by
/// `tool/check_landmarks.py`.
class Landmark {
  Landmark({
    required this.id,
    required this.iso,
    required this.name,
    required this.lon,
    required this.lat,
    required this.sprite,
    required this.priority,
  });

  final String id;
  final String iso;
  final String name; // Czech, as a children's atlas would call it
  final double lon;
  final double lat;
  final String sprite;

  /// 1–3; the higher one wins when two icons would overlap, and each
  /// country's highest is its hero.
  final int priority;

  factory Landmark.fromJson(Map<String, dynamic> j) => Landmark(
    id: j['id'] as String,
    iso: j['iso'] as String,
    name: j['n'] as String,
    lon: (j['o'] as num).toDouble(),
    lat: (j['a'] as num).toDouble(),
    sprite: j['s'] as String? ?? j['id'] as String,
    priority: (j['p'] as num?)?.toInt() ?? 1,
  );
}

class LandmarkIndex {
  LandmarkIndex(this.landmarks) {
    for (final l in landmarks) {
      final h = _hero[l.iso];
      if (h == null || l.priority > h.priority) _hero[l.iso] = l;
    }
  }

  static final empty = LandmarkIndex(const []);

  final List<Landmark> landmarks;
  final _hero = <String, Landmark>{};

  /// The one landmark that stands for [iso], or null when it has none yet.
  Landmark? heroOf(String iso) => _hero[iso];

  static Future<LandmarkIndex> load() async {
    final list =
        jsonDecode(await rootBundle.loadString('assets/geo/landmarks.json'))
            as List;
    return LandmarkIndex([
      for (final j in list) Landmark.fromJson(j as Map<String, dynamic>),
    ]);
  }
}

final landmarkIndexProvider = FutureProvider<LandmarkIndex>(
  (ref) => LandmarkIndex.load(),
);
