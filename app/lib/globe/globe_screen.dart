import 'dart:math' as math;

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../packs/pack_manifest.dart';
import '../packs/pack_providers.dart';
import '../packs/storage_sheet.dart' show StorageSheet, formatBytes;
import '../rag/rag_providers.dart';
import '../story/story_draft.dart';
import '../theme/kid_text.dart';
import 'country.dart';
import 'feature.dart';
import 'globe_icons.dart';
import 'globe_painter.dart';
import 'globe_projection.dart';
import 'landmark.dart';
import 'region.dart';

/// The sphere itself, and the name of whatever is dead centre. Both are
/// keyed because tests drag/tap the one and read the other, and neither
/// is otherwise distinguishable from the Scaffold's own chrome.
const globeCanvasKey = Key('globe-canvas');
const globeFocusNameKey = Key('globe-focus-name');
const globeDownloadKey = Key('globe-download');
const globeSightKey = Key('globe-sight');
const globeZoomInKey = Key('globe-zoom-in');
const globeZoomOutKey = Key('globe-zoom-out');
const globeWholeKey = Key('globe-whole');

/// STORYTELLER_PLAN.md §1.1b — the spinning globe, the app's home
/// screen. Drag to rotate, fling to keep spinning, pinch to zoom, tap a
/// country or an icon to turn to it, or hit "Roztočit" for the plan's
/// random landing. Whatever sits dead centre is what you're "looking
/// at": it's highlighted and named in the card below.
///
/// Clusters of small countries start out merged into one region
/// (STORYTELLER_GLOBE_PLAN.md §1.1) and come apart as you zoom in.
class GlobeScreen extends ConsumerStatefulWidget {
  const GlobeScreen({super.key});

  @override
  ConsumerState<GlobeScreen> createState() => _GlobeScreenState();
}

class _GlobeScreenState extends ConsumerState<GlobeScreen>
    with SingleTickerProviderStateMixin {
  // Centre of view. The placeholder is central Europe; once the index
  // arrives, _aimAtRichest aims at whichever country we actually have
  // the most to offer from, so the app never opens on a dead end.
  double _lat = 50;
  double _lon = 12;

  /// 1 shows the whole planet; above that the sphere outgrows the canvas
  /// (STORYTELLER_GLOBE_PLAN.md §1.2) until countries the size of Czechia
  /// are big enough to tap.
  double _zoom = 1;
  static const _maxZoom = 8.0;

  // Angular velocity in degrees per second, decayed by friction.
  double _vLon = 0;
  double _vLat = 0;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  /// An animated move of the view — turning to a tapped country, flying
  /// into a region. Shares the ticker with the fling: only one of the two
  /// is ever in charge of the view.
  _Flight? _flight;

  // Pinch: the zoom the gesture started from, and whether it ever had two
  // fingers down (a pinch that ends must not fling the globe).
  double _zoomAtScaleStart = 1;
  bool _pinched = false;

  /// The icon the user tapped, named on the card until they move on.
  PlacedIcon? _pin;

  /// What [layoutIcons] placed in the last build — the tap handler hits
  /// against exactly what the painter drew.
  List<PlacedIcon> _icons = const [];

  final _rng = math.Random();

  /// Degrees of spin left in the deliberate "Roztočit" throw, so the
  /// random landing can't be nudged mid-flight by leftover friction.
  bool _spinning = false;

  /// The opening view is picked once, the first time the index is
  /// available — after that _lat/_lon belong to the user's fingers.
  bool _aimed = false;

  /// Packs (lib/rag/) load after the geo index. Once they do, the globe
  /// turns to the country they serve best — CZ today — unless the user
  /// has already turned it themselves. Before this, the app opened on
  /// Germany and nothing the packs added was anywhere in sight.
  bool _aimedAtPack = false;
  bool _touched = false;

  void _aimAtPackRichest(CountryIndex index, Map<String, int> packCounts) {
    _aimedAtPack = true;
    final best = packCounts.entries
        .reduce((a, b) => b.value > a.value ? b : a)
        .key;
    final c = index.countries.where((c) => c.iso == best).firstOrNull;
    if (c == null) return;
    _lat = c.lat.clamp(-85.0, 85.0);
    _lon = _wrapLon(c.lon);
  }

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
    final covered = [
      for (final c in index.countries)
        if (c.motifs > 0) c,
    ];
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

    final flight = _flight;
    if (flight != null) {
      flight.t = math.min(1, flight.t + dt / flight.seconds);
      final k = Curves.easeInOutCubic.transform(flight.t);
      VoidCallback? then;
      setState(() {
        _lon = _wrapLon(flight.lon0 + flight.dLon * k);
        _lat = flight.lat0 + (flight.lat1 - flight.lat0) * k;
        _zoom = flight.zoom0 + (flight.zoom1 - flight.zoom0) * k;
        if (flight.t >= 1) {
          _flight = null;
          then = flight.then;
        }
      });
      then?.call();
      if (_flight == null && _vLon == 0 && _vLat == 0) _ticker.stop();
      return;
    }

    if (_vLon == 0 && _vLat == 0) {
      _ticker.stop();
      return;
    }

    // Exponential friction: a fling coasts for a couple of seconds and
    // settles, instead of stopping dead or spinning forever.
    final decay = math.pow(0.12, dt).toDouble();
    var landed = false;
    setState(() {
      _lon = _wrapLon(_lon - _vLon * dt);
      _lat = (_lat - _vLat * dt).clamp(-85.0, 85.0);
      _vLon *= decay;
      _vLat *= decay;
      if (_vLon.abs() < 1 && _vLat.abs() < 1) {
        _vLon = 0;
        _vLat = 0;
        landed = _spinning;
        _spinning = false;
        _ticker.stop();
      }
    });
    if (landed) _afterSpin();
  }

  /// Animates the view to ([lat], [lon]) at [zoom], the short way round.
  void _flyTo(
    double lat,
    double lon,
    double zoom, {
    int ms = 420,
    VoidCallback? then,
  }) {
    var dLon = lon - _lon;
    if (dLon > 180) dLon -= 360;
    if (dLon < -180) dLon += 360;
    _vLon = 0;
    _vLat = 0;
    _flight = _Flight(
      lat0: _lat,
      lon0: _lon,
      zoom0: _zoom,
      lat1: lat.clamp(-85.0, 85.0),
      dLon: dLon,
      zoom1: zoom.clamp(1.0, _maxZoom),
      seconds: ms / 1000,
      then: then,
    );
    _ensureTicking();
  }

  double _baseRadius(Size size) => math.min(size.width, size.height) / 2 - 8;

  double _degreesPerPixel(double radius) =>
      90 / radius; // edge of the disc ≈ 90° away from centre

  /// How far out to sea a point still counts as the nearest country.
  /// Shrinks with zoom: 12° is "near the coast" on the whole globe and
  /// half the screen once you are looking at the Aegean.
  double get _oceanSnap => 12 / _zoom;

  // Pan and pinch arrive through the one scale recogniser — Flutter
  // can't run a pan and a scale recogniser on the same detector.
  void _onScaleStart(ScaleStartDetails d) {
    _touched = true;
    _zoomAtScaleStart = _zoom;
    _pinched = d.pointerCount > 1;
    setState(() {
      _flight = null;
      _spinning = false;
      _vLon = 0;
      _vLat = 0;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails d, double baseRadius) {
    if (d.pointerCount > 1) _pinched = true;
    setState(() {
      _pin = null;
      if (d.pointerCount > 1) {
        _zoom = (_zoomAtScaleStart * d.scale).clamp(1.0, _maxZoom);
      }
      final k = _degreesPerPixel(baseRadius * _zoom);
      _lon = _wrapLon(_lon - d.focalPointDelta.dx * k);
      _lat = (_lat + d.focalPointDelta.dy * k).clamp(-85.0, 85.0);
    });
  }

  void _onScaleEnd(ScaleEndDetails d, double baseRadius) {
    if (_pinched) return; // lifting one finger of a pinch is not a throw
    final k = _degreesPerPixel(baseRadius * _zoom);
    setState(() {
      _vLon = d.velocity.pixelsPerSecond.dx * k;
      _vLat = -d.velocity.pixelsPerSecond.dy * k;
    });
    _ensureTicking();
  }

  /// The plan's "Náhoda": a hard throw that lands somewhere arbitrary.
  /// A throw is a whole-planet thing, so a zoomed-in view backs out first.
  void _spin() {
    _touched = true;
    void spin() {
      setState(() {
        _spinning = true;
        _vLon = (400 + _rng.nextDouble() * 500) * (_rng.nextBool() ? 1 : -1);
        _vLat = (_rng.nextDouble() - 0.5) * 120;
      });
      _ensureTicking();
    }

    setState(() => _pin = null);
    if (_zoom > 1.2) {
      setState(() => _spinning = true);
      _flyTo(_lat, _lon, 1, ms: 300, then: spin);
    } else {
      spin();
    }
  }

  /// A throw that lands inside a merged region has only picked "Evropa";
  /// flying in where it landed turns that into a country.
  void _afterSpin() {
    final index = ref.read(countryIndexProvider).value;
    final regions = ref.read(regionIndexProvider).value;
    final here = index?.at(_lon, _lat, oceanSnapDegrees: _oceanSnap);
    final region = here == null ? null : regions?.mergedAt(here.iso, _zoom);
    if (region != null) _flyTo(_lat, _lon, region.zoomTo);
  }

  void _onTapUp(TapUpDetails d, GlobeProjection proj, CountryIndex index) {
    _touched = true;
    // Icons stand above the land, so they get the tap first — except the
    // one icon of a merged region: it is drawn large over half of Europe,
    // and a tap there means the country underneath (which flies in anyway).
    for (final icon in _icons.reversed) {
      if (icon.region == null && icon.rect.deflate(icon.rect.width * 0.1).contains(d.localPosition)) {
        setState(() {
          _spinning = false;
          _pin = icon;
        });
        _flyTo(icon.lat, icon.lon, _zoom);
        return;
      }
    }
    final hit = proj.unproject(d.localPosition);
    if (hit == null) return; // tapped the background, not the ball
    final country = index.at(hit.lon, hit.lat, oceanSnapDegrees: _oceanSnap);
    if (country == null) return; // open ocean
    _turnTo(country);
  }

  /// Turns to [c]. From the whole globe, a country inside a merged region
  /// is too small to have been aimed at, so the turn also flies in to
  /// where the region's countries can be told apart.
  void _turnTo(Country c) {
    final region = ref.read(regionIndexProvider).value?.mergedAt(c.iso, _zoom);
    setState(() {
      _spinning = false;
      _pin = null;
    });
    _flyTo(
      c.lat,
      c.lon,
      region?.zoomTo ?? _zoom,
      ms: region == null ? 300 : 420,
    );
  }

  void _zoomBy(double factor) {
    _touched = true;
    setState(() => _spinning = false);
    _flyTo(_lat, _lon, _zoom * factor, ms: 260);
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
            style: context.kid(KidRole.body, size: 16, color: StoryInk.soft),
          ),
        ),
      );
    }
    if (!_aimed) _aimAtRichest(index);

    // Regions, landmarks and nature dress the globe; it works without
    // them (they load a moment after the countries, or not at all).
    final regions = ref.watch(regionIndexProvider).value ?? RegionIndex.empty;
    final landmarks =
        ref.watch(landmarkIndexProvider).value ?? LandmarkIndex.empty;
    final features =
        ref.watch(featureIndexProvider).value ?? FeatureIndex.empty;

    final packCounts = ref.watch(packMotifCountsProvider);
    if (!_aimedAtPack && !_touched && packCounts.isNotEmpty) {
      _aimAtPackRichest(index, packCounts);
    }
    final focused = index.at(_lon, _lat, oceanSnapDegrees: _oceanSnap);
    final region = focused == null
        ? null
        : regions.mergedAt(focused.iso, _zoom);
    final covered = ref.watch(coveredCountriesProvider);
    final repo = ref.watch(packRepositoryProvider).value;
    final manifest = ref.watch(packManifestProvider).value;
    ref.watch(installedPacksRevisionProvider);
    final downloads = ref.watch(packDownloadsProvider);
    // Free tales come per continent (§11). Offered only where nothing from
    // the country is on the device yet and its continent isn't bundled
    // (Evropa is in the binary) or already downloaded.
    final continent = focused == null
        ? null
        : manifest?.continentOf(focused.iso);
    final offer =
        focused == null ||
            region != null ||
            repo == null ||
            continent == null ||
            continent.bundled ||
            continent.free == null ||
            covered.contains(focused.iso) ||
            repo.hasContinent(continent.code)
        ? null
        : continent;

    // What the card says is here besides the country: the icon the user
    // tapped, else the country's own landmark; and whatever nature the
    // centre of view is standing in.
    final pin = _pin;
    final sight = pin != null
        ? pin.name
        : region != null
        ? null
        : focused == null
        ? null
        : landmarks.heroOf(focused.iso)?.name;
    final nature = pin?.nature ?? false ? null : _natureAt(features);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: const StoryTitle('Odkud bude pohádka?'),
        actions: [
          if (repo != null)
            IconButton(
              tooltip: 'Stažené pohádky',
              icon: const Icon(Icons.sd_storage_outlined),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (_) => const StorageSheet(),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              // Both hints are laid out and one is shown, so the taller of
              // the two sets the height and the globe below doesn't shift
              // when zooming swaps them.
              child: IndexedStack(
                index: _zoom < 1.2 ? 0 : 1,
                children: [
                  for (final hint in const [
                    'Roztoč planetu nebo ťukni na zemi. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.',
                    'Ťukni na zemi nebo na stavbu. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.',
                  ])
                    Text(hint, style: context.kid(KidRole.body, size: 15, color: StoryInk.soft)),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final baseRadius = _baseRadius(size);
                  final proj = GlobeProjection(
                    centerLat: _lat,
                    centerLon: _lon,
                    radius: baseRadius * _zoom,
                    center: Offset(size.width / 2, size.height / 2),
                  );
                  final icons = _icons = layoutIcons(
                    proj: proj, focusIso: region == null ? focused?.iso : null,
                    size: size,
                    zoom: _zoom,
                    landmarks: landmarks,
                    features: features,
                    regions: regions,
                  );
                  return Stack(
                    children: [
                      GestureDetector(
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: (d) => _onScaleUpdate(d, baseRadius),
                        onScaleEnd: (d) => _onScaleEnd(d, baseRadius),
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
                            zoom: _zoom,
                            regions: regions,
                            features: features,
                            icons: icons,
                            atlas: ref.watch(spriteAtlasProvider),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 8,
                        child: _ZoomButtons(
                          zoom: _zoom,
                          maxZoom: _maxZoom,
                          onIn: () => _zoomBy(1.6),
                          onOut: () => _zoomBy(1 / 1.6),
                          onWhole: () => _zoomBy(1 / _maxZoom),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            _CountryCard(
              country: focused,
              region: region,
              sight: sight,
              nature: nature,
              onZoomIn: region == null
                  ? null
                  : () => _flyTo(_lat, _lon, region.zoomTo),
              spinning: _spinning,
              onSpin: _spin,
              // A country we have nothing from is a dead end on purpose.
              // Letting it through would fall back to the full pool and
              // quietly serve a German tale under a Czech label — the
              // one thing the globe promises not to do.
              packMotifs: focused == null ? 0 : packCounts[focused.iso] ?? 0,
              packTales: focused == null
                  ? 0
                  : ref.watch(packTaleCountsProvider)[focused.iso] ?? 0,
              offer: offer,
              progress: offer == null ? null : downloads[offer.code],
              onDownload: offer == null
                  ? null
                  : () async {
                      final err = await ref
                          .read(packDownloadsProvider.notifier)
                          .installContinent(offer.code);
                      if (err != null && context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(err)));
                      }
                    },
              onUse: focused == null || !covered.contains(focused.iso)
                  ? null
                  : () {
                      ref
                          .read(storyDraftProvider.notifier)
                          .setCountry(focused.iso, focused.name);
                      repo?.touch(focused.iso);
                      context.go('/cast');
                    },
            ),
          ],
        ),
      ),
    );
  }

  /// The desert, forest, lake or river the centre of view is standing in —
  /// the same "what am I looking at" rule the country highlight follows.
  String? _natureAt(FeatureIndex features) {
    // Within a finger's width of the river on screen, whatever the zoom.
    final near = 1.6 / _zoom;
    final cosLat = math.cos(_lat * math.pi / 180).abs();
    GeoFeature? area;
    for (final f in features.features) {
      if (_zoom < f.minZoom) continue;
      if (f.type == FeatureType.river) {
        for (var i = 0; i < f.pts.length; i += 2) {
          final dLon = (f.pts[i] - _lon) * cosLat, dLat = f.pts[i + 1] - _lat;
          if (dLon * dLon + dLat * dLat < near * near) return f.name;
        }
      } else if (f.contains(_lon, _lat)) {
        // A lake inside a forest is the more specific answer.
        if (area == null || f.kind == AreaKind.lake) area = f;
      }
    }
    return area?.name;
  }
}

class _Flight {
  _Flight({
    required this.lat0,
    required this.lon0,
    required this.zoom0,
    required this.lat1,
    required this.dLon,
    required this.zoom1,
    required this.seconds,
    this.then,
  });

  final double lat0, lon0, zoom0, lat1, dLon, zoom1, seconds;
  final VoidCallback? then;
  double t = 0;
}

/// Zoom without a pinch — small hands, and one of them is holding the
/// phone. "Celá planeta" only shows once there is somewhere to go back to.
class _ZoomButtons extends StatelessWidget {
  const _ZoomButtons({
    required this.zoom,
    required this.maxZoom,
    required this.onIn,
    required this.onOut,
    required this.onWhole,
  });

  final double zoom;
  final double maxZoom;
  final VoidCallback onIn;
  final VoidCallback onOut;
  final VoidCallback onWhole;

  @override
  Widget build(BuildContext context) {
    Widget button(Key key, IconData icon, String tip, VoidCallback? onTap) => Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Tooltip(
        message: tip,
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 2,
          child: InkWell(
            key: key,
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox.square(dimension: 44, child: Icon(icon, color: onTap == null ? const Color(0x553E2723) : const Color(0xFF3E2723))),
          ),
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (zoom > 1.2)
          button(globeWholeKey, Icons.public, 'Celá planeta', onWhole),
        button(
          globeZoomInKey,
          Icons.add,
          'Přiblížit',
          zoom >= maxZoom ? null : onIn,
        ),
        button(
          globeZoomOutKey,
          Icons.remove,
          'Oddálit',
          zoom <= 1 ? null : onOut,
        ),
      ],
    );
  }
}

/// The plan's "vizitka země" (§1.1b) — what you're looking at, what we
/// actually have from there, and the way into the story from here.
class _CountryCard extends StatelessWidget {
  const _CountryCard({required this.country, required this.packMotifs, required this.packTales, required this.spinning, required this.onSpin, required this.onUse, this.region, this.sight, this.nature, this.onZoomIn, this.offer, this.progress, this.onDownload});

  final Country? country;

  /// Set while the country under the centre is still merged into its
  /// region: the card then names the region and offers the way in, since
  /// a story needs a country and none has really been picked yet.
  final Region? region;
  final String? sight; // a landmark: the tapped icon, else the country's own
  final String? nature; // the desert, forest, lake or river under the centre
  final VoidCallback? onZoomIn;
  final int packMotifs; // RAG pack motifs with a Czech title (lib/rag/)
  final int packTales; // source tales of those motifs (pack_tales)
  final bool spinning;
  final VoidCallback onSpin;
  final VoidCallback? onUse;

  /// The free pack of the country's continent, when it's on offer and not installed yet.
  final ContinentPacks? offer;
  final double? progress; // 0..1 while downloading
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final c = country;
    final r = region;
    final sights = [?sight, ?nature].join(' · ');
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
                    // Every row of the card keeps its height whatever it has
                    // to say. The card sits under the globe, so a card that
                    // grew a line for a long name or a download offer pushed
                    // the planet up and down as the focus moved from country
                    // to country.
                    SizedBox(
                      height: 38,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: BubbleText(
                          r?.name ?? c?.name ?? 'Širé moře',
                          key: globeFocusNameKey,
                          size: 24,
                          maxLines: 1,
                          align: TextAlign.start,
                          palette: c != null && c.motifs > 0 ? KidPalette.mint : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: sights.isEmpty ? null : Text(sights, key: globeSightKey, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF3E2723), fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 36,
                      child: Text(
                      r != null
                          ? '${r.isos.length} zemí pohromadě. Přibliž se a vyber si jednu.'
                          : c == null
                          ? 'Otoč planetu na nějakou zemi.'
                          // What the pickers can actually offer wins over the
                          // geo asset's corpus counts, once packs know their tales.
                          : packMotifs > 0 && packTales > 0
                              ? motifsFromTales(packMotifs, packTales)
                              : c.motifs > 0 && packMotifs > 0
                                  ? '${motifsFromTales(c.motifs, c.tales)} + $packMotifs z balíčku'
                                  : c.motifs > 0
                                      ? motifsFromTales(c.motifs, c.tales)
                                      : packMotifs > 0
                                          ? '$packMotifs ${_motifs(packMotifs)} z balíčku'
                                          : 'Odsud zatím žádné pohádky nemáme.',
                      style: TextStyle(
                        color: r == null && c != null && (c.motifs > 0 || packMotifs > 0) ? const Color(0xFF2E7D32) : const Color(0x993E2723),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          // One slot, one height. A country whose continent still has to be
          // downloaded has nothing to tell yet, so the download takes the
          // place of the dead "Vyprávět" button instead of stacking above it.
          SizedBox(
            width: double.infinity,
            height: 48,
            child: switch (offer) {
              final o? when o.free != null && progress != null => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Stahuji pohádky… ${(progress! * 100).round()} %', style: const TextStyle(color: Color(0x993E2723), fontSize: 13)),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(value: progress, color: const Color(0xFF2E7D32)),
                  ],
                ),
              final o? when o.free != null => FilledButton.icon(
                  key: globeDownloadKey,
                  onPressed: onDownload,
                  icon: const Icon(Icons.download, size: 18),
                  label: FittedBox(fit: BoxFit.scaleDown, child: Text('Stáhnout balíček ${o.name}: ${o.free!.tales} ${_tales(o.free!.tales)} zdarma (${formatBytes(o.free!.size)})')),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                ),
              _ => FilledButton(
                  onPressed: r != null ? onZoomIn : onUse,
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text(r != null ? 'Přiblížit ${r.name} →' : c == null ? 'Vyprávět odsud' : 'Vyprávět z ${c.name} →')),
                ),
            },
          ),
        ],
      ),
    );
  }
}

String _tales(int n) => n == 1 ? 'pohádku' : (n >= 2 && n <= 4 ? 'pohádky' : 'pohádek');

String _motifs(int n) => n == 1 ? 'motiv' : (n >= 2 && n <= 4 ? 'motivy' : 'motivů');

/// "N motivů z M pohádek" with the Czech plural of N and the genitive of M
/// ("z 1 pohádky", "z 2 pohádek").
String motifsFromTales(int motifs, int tales) => '$motifs ${_motifs(motifs)} z $tales ${tales == 1 ? 'pohádky' : 'pohádek'}';
