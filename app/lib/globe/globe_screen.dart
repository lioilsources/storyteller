import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../rag/rag_providers.dart';
import '../story/story_draft.dart';
import 'country.dart';
import 'globe_painter.dart';
import 'globe_projection.dart';

/// The sphere itself, and the name of whatever is dead centre. Both are
/// keyed because tests drag/tap the one and read the other, and neither
/// is otherwise distinguishable from the Scaffold's own chrome.
const globeCanvasKey = Key('globe-canvas');
const globeFocusNameKey = Key('globe-focus-name');

/// STORYTELLER_PLAN.md §1.1b — the spinning globe, the app's home
/// screen. Drag to rotate, fling to keep spinning, tap a country to
/// turn to it, or hit "Roztočit" for the plan's random landing.
/// Whatever sits dead centre is what you're "looking at": it's
/// highlighted and named in the card below.
class GlobeScreen extends ConsumerStatefulWidget {
  const GlobeScreen({super.key});

  @override
  ConsumerState<GlobeScreen> createState() => _GlobeScreenState();
}

class _GlobeScreenState extends ConsumerState<GlobeScreen> with SingleTickerProviderStateMixin {
  // Centre of view. The placeholder is central Europe; once the index
  // arrives, _aimAtRichest aims at whichever country we actually have
  // the most to offer from, so the app never opens on a dead end.
  double _lat = 50;
  double _lon = 12;

  // Angular velocity in degrees per second, decayed by friction.
  double _vLon = 0;
  double _vLat = 0;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  final _rng = math.Random();

  /// Degrees of spin left in the deliberate "Roztočit" throw, so the
  /// random landing can't be nudged mid-flight by leftover friction.
  bool _spinning = false;

  /// The opening view is picked once, the first time the index is
  /// available — after that _lat/_lon belong to the user's fingers.
  bool _aimed = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  /// Opens on the country with the most extracted motifs, so the app
  /// never starts on a dead end. Derived from the asset rather than
  /// hardcoded, so it follows the corpus as more languages get fetched
  /// instead of going stale.
  void _aimAtRichest(CountryIndex index) {
    _aimed = true;
    final covered = [for (final c in index.countries) if (c.motifs > 0) c];
    if (covered.isEmpty) return;
    final richest = covered.reduce((a, b) => b.motifs > a.motifs ? b : a);
    _lat = richest.lat.clamp(-85.0, 85.0);
    _lon = _wrapLon(richest.lon);
  }

  /// The ticker only runs while the globe actually has momentum —
  /// leaving it started would repaint at display rate forever and cost
  /// battery for a stationary picture.
  void _ensureTicking() {
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_lastTick == Duration.zero) {
      _lastTick = elapsed; // first frame after start has no interval yet
      return;
    }
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (dt <= 0) return;
    if (_vLon == 0 && _vLat == 0) {
      _ticker.stop();
      return;
    }

    // Exponential friction: a fling coasts for a couple of seconds and
    // settles, instead of stopping dead or spinning forever.
    final decay = math.pow(0.12, dt).toDouble();
    setState(() {
      _lon = _wrapLon(_lon - _vLon * dt);
      _lat = (_lat - _vLat * dt).clamp(-85.0, 85.0);
      _vLon *= decay;
      _vLat *= decay;
      if (_vLon.abs() < 1 && _vLat.abs() < 1) {
        _vLon = 0;
        _vLat = 0;
        _spinning = false;
        _ticker.stop();
      }
    });
  }

  double _degreesPerPixel(double radius) => 90 / radius; // edge of the disc ≈ 90° away from centre

  void _onPanUpdate(DragUpdateDetails d, double radius) {
    setState(() {
      _spinning = false;
      _vLon = 0;
      _vLat = 0;
      final k = _degreesPerPixel(radius);
      _lon = _wrapLon(_lon - d.delta.dx * k);
      _lat = (_lat + d.delta.dy * k).clamp(-85.0, 85.0);
    });
  }

  void _onPanEnd(DragEndDetails d, double radius) {
    final k = _degreesPerPixel(radius);
    setState(() {
      _vLon = d.velocity.pixelsPerSecond.dx * k;
      _vLat = -d.velocity.pixelsPerSecond.dy * k;
    });
    _ensureTicking();
  }

  /// The plan's "Náhoda": a hard throw that lands somewhere arbitrary.
  void _spin() {
    setState(() {
      _spinning = true;
      _vLon = (400 + _rng.nextDouble() * 500) * (_rng.nextBool() ? 1 : -1);
      _vLat = (_rng.nextDouble() - 0.5) * 120;
    });
    _ensureTicking();
  }

  void _onTapUp(TapUpDetails d, GlobeProjection proj, CountryIndex index) {
    final hit = proj.unproject(d.localPosition);
    if (hit == null) return; // tapped the background, not the ball
    final country = index.at(hit.lon, hit.lat);
    if (country == null) return; // open ocean
    _turnTo(country);
  }

  void _turnTo(Country c) {
    setState(() {
      _spinning = false;
      _vLon = 0;
      _vLat = 0;
      // Spin the short way round rather than unwinding the long way.
      var delta = c.lon - _lon;
      if (delta > 180) delta -= 360;
      if (delta < -180) delta += 360;
      _lon = _wrapLon(_lon + delta);
      _lat = c.lat.clamp(-85.0, 85.0);
    });
  }

  static double _wrapLon(double lon) {
    var l = (lon + 180) % 360;
    if (l < 0) l += 360;
    return l - 180;
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(countryIndexProvider).value;
    if (index == null) {
      // No spinner: an always-mounted CircularProgressIndicator never
      // lets pumpAndSettle finish, and 114 KB of JSON is a blink anyway.
      final failed = ref.watch(countryIndexProvider).hasError;
      return Scaffold(
        backgroundColor: const Color(0xFFFFFBF2),
        body: Center(
          child: Text(
            failed ? 'Planetu se nepodařilo načíst.' : 'Chystám planetu…',
            style: const TextStyle(color: Color(0x993E2723)),
          ),
        ),
      );
    }
    if (!_aimed) _aimAtRichest(index);

    final focused = index.at(_lon, _lat);
    final covered = ref.watch(coveredCountriesProvider);
    final packCounts = ref.watch(packMotifCountsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: const Text('Odkud bude pohádka?'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Roztoč planetu nebo ťukni na zemi. Zelené země už mají '
                'pohádky z našeho korpusu, šedé zatím ne.',
                style: TextStyle(color: Color(0x993E2723), fontSize: 13, height: 1.3),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                  final radius = math.min(size.width, size.height) / 2 - 8;
                  final proj = GlobeProjection(
                    centerLat: _lat,
                    centerLon: _lon,
                    radius: radius,
                    center: Offset(size.width / 2, size.height / 2),
                  );
                  return GestureDetector(
                    onPanUpdate: (d) => _onPanUpdate(d, radius),
                    onPanEnd: (d) => _onPanEnd(d, radius),
                    onTapUp: (d) => _onTapUp(d, proj, index),
                    child: CustomPaint(
                      key: globeCanvasKey,
                      size: size,
                      painter: GlobePainter(
                        index: index,
                        centerLat: _lat,
                        centerLon: _lon,
                        highlightIso: focused?.iso,
                        coveredIsos: covered,
                      ),
                    ),
                  );
                },
              ),
            ),
            _CountryCard(
              country: focused,
              spinning: _spinning,
              onSpin: _spin,
              // A country we have nothing from is a dead end on purpose.
              // Letting it through would fall back to the full pool and
              // quietly serve a German tale under a Czech label — the
              // one thing the globe promises not to do.
              packMotifs: focused == null ? 0 : packCounts[focused.iso] ?? 0,
              onUse: focused == null || !covered.contains(focused.iso)
                  ? null
                  : () {
                      ref.read(storyDraftProvider.notifier).setCountry(focused.iso, focused.name);
                      context.go('/cast');
                    },
            ),
          ],
        ),
      ),
    );
  }
}

/// The plan's "vizitka země" (§1.1b) — what you're looking at, what we
/// actually have from there, and the way into the story from here.
class _CountryCard extends StatelessWidget {
  const _CountryCard({required this.country, required this.packMotifs, required this.spinning, required this.onSpin, required this.onUse});

  final Country? country;
  final int packMotifs; // RAG pack motifs with a Czech title (lib/rag/)
  final bool spinning;
  final VoidCallback onSpin;
  final VoidCallback? onUse;

  @override
  Widget build(BuildContext context) {
    final c = country;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c?.name ?? 'Širé moře',
                      key: globeFocusNameKey,
                      style: const TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c == null
                          ? 'Otoč planetu na nějakou zemi.'
                          : c.motifs > 0 && packMotifs > 0
                              ? '${c.motifs} motivů z ${c.tales} pohádek + $packMotifs z balíčku'
                              : c.motifs > 0
                                  ? '${c.motifs} motivů z ${c.tales} pohádek'
                                  : packMotifs > 0
                                      ? '$packMotifs motivů z balíčku'
                                      : 'Odsud zatím žádné pohádky nemáme.',
                      style: TextStyle(
                        color: c != null && (c.motifs > 0 || packMotifs > 0) ? const Color(0xFF2E7D32) : const Color(0x993E2723),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: spinning ? null : onSpin,
                icon: const Icon(Icons.rotate_right, size: 18),
                label: const Text('Roztočit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF3E2723),
                  side: const BorderSide(color: Color(0x333E2723)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onUse,
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
              child: Text(c == null ? 'Vyprávět odsud' : 'Vyprávět z ${c.name} →'),
            ),
          ),
        ],
      ),
    );
  }
}
