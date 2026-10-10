/// `manifest.v4.json` schema 4 (STORYTELLER_PACKS_V2_PLAN.md §1.3), as
/// `rag.region_packs` writes it and GitHub Pages serves it.
///
/// Tales ship per region (`regions`): ten free ones (`free`, in the app
/// binary when `bundled`) and paid parts of fifty (`parts`). A country has
/// no pack of its own; `countries` says how many of its tales are in
/// which pack, so the globe can tell without downloading anything.
/// `scenes` are free all-scenes packs per country, as in schema 3.
///
/// Paid parts carry no URL on purpose: the client composes it from
/// `base_urls.paid` only after the store says the user owns the product.
class PackManifest {
  PackManifest({required this.schema, required this.lang, required this.minAppVersion, required this.freeBase, required this.paidBase, required this.regions, required this.countries, this.scenes = const {}});

  /// The only schema this client reads. Schema 3 (free packs per
  /// continent, paid per country) lives on at `manifest.json` for the 1.6
  /// clients; a newer one is ignored (the cached copy stays in use)
  /// rather than misread.
  static const supportedSchema = 4;

  final int schema;
  final String lang;
  final String minAppVersion;
  final String freeBase;
  final String paidBase;
  final Map<String, RegionPacks> regions; // keyed by upper-case code: CZSK, AFRI…, in the manifest's order
  final Map<String, CountryTales> countries; // keyed by upper-case ISO, like the rest of the app
  final Map<String, ScenePacks> scenes; // keyed by upper-case ISO

  /// The region whose packs carry [iso]'s tales, or null when the
  /// manifest has nothing from there.
  RegionPacks? regionOf(String iso) {
    final r = regions[countries[iso]?.region];
    if (r != null) return r;
    for (final r in regions.values) {
      if (r.countries.contains(iso)) return r;
    }
    return null;
  }

  factory PackManifest.fromJson(Map<String, dynamic> j) {
    final base = j['base_urls'] as Map<String, dynamic>;
    return PackManifest(
      schema: j['schema'] as int,
      lang: j['lang'] as String? ?? 'cs',
      minAppVersion: j['min_app_version'] as String? ?? '0.0.0',
      freeBase: base['free'] as String,
      paidBase: base['paid'] as String,
      regions: {
        for (final e in ((j['regions'] as Map<String, dynamic>?) ?? const {}).entries) e.key.toUpperCase(): RegionPacks.fromJson(e.key.toUpperCase(), e.value as Map<String, dynamic>),
      },
      countries: {
        for (final e in ((j['countries'] as Map<String, dynamic>?) ?? const {}).entries) e.key.toUpperCase(): CountryTales.fromJson(e.key.toUpperCase(), e.value as Map<String, dynamic>),
      },
      scenes: {
        for (final e in ((j['scenes'] as Map<String, dynamic>?) ?? const {}).entries)
          if (ScenePacks.fromJson(e.key.toUpperCase(), e.value as Map<String, dynamic>) case final s? when s.free != null) e.key.toUpperCase(): s,
      },
    );
  }
}

PackFile _file(Map<String, dynamic> f) => PackFile(version: f['version'] as int, size: f['size'] as int, sha256: f['sha256'] as String, tales: f['tales'] as int? ?? 0, images: f['images'] as int? ?? 0, file: f['file'] as String);

/// One region's packs: `region.<KOD>.<lang>.free` and `.p<N>`.
class RegionPacks {
  RegionPacks({required this.code, required this.name, required this.bundled, required this.countries, this.free, this.parts = const []});

  final String code;
  final String name; // Czech, nominative: "Afrika"
  final bool bundled; // the free pack is in the app binary: never downloaded
  final Set<String> countries;
  final PackFile? free;
  final List<PartPack> parts; // in order, part 1 first

  PartPack? part(int n) => parts.where((p) => p.n == n).firstOrNull;

  factory RegionPacks.fromJson(String code, Map<String, dynamic> j) {
    final f = j['free'] as Map<String, dynamic>?;
    final names = (j['name'] as Map<String, dynamic>?) ?? const {};
    return RegionPacks(
      code: code,
      name: names['cs'] as String? ?? names['en'] as String? ?? code,
      bundled: j['bundled'] as bool? ?? false,
      countries: {for (final c in (j['countries'] as List? ?? const [])) (c as String).toUpperCase()},
      free: f == null ? null : _file(f),
      parts: [
        for (final p in (j['parts'] as List? ?? const []).cast<Map<String, dynamic>>()) PartPack(n: p['n'] as int, productId: p['product_id'] as String, file: _file(p)),
      ]..sort((a, b) => a.n.compareTo(b.n)),
    );
  }
}

/// A paid part of fifty tales, product `pack_<kod>_<N>`.
class PartPack {
  PartPack({required this.n, required this.productId, required this.file});

  final int n;
  final String productId;
  final PackFile file;

  /// `<paid base>region-<kod>-p<N>-v<version>/<kod>-p<N>.zip`.
  String url(String paidBase, String code) => '${paidBase}region-${code.toLowerCase()}-p$n-v${file.version}/${file.file}';
}

/// How many tales of one country the packs hold, and where.
class CountryTales {
  CountryTales({required this.iso, required this.name, required this.region, this.tales = 0, this.free = 0, this.parts = const {}, this.coming = 0});

  final String iso;
  final String name;
  final String region; // upper-case region code
  final int tales; // in built packs: free + parts
  final int free; // of them in the region's free pack
  final Map<int, int> parts; // part number → tales of this country in it
  final int coming; // in the corpus, waiting for a part to fill

  int get inParts => parts.values.fold(0, (a, b) => a + b);

  factory CountryTales.fromJson(String iso, Map<String, dynamic> j) {
    final where = (j['in'] as Map<String, dynamic>?) ?? const {};
    return CountryTales(
      iso: iso,
      name: ((j['name'] as Map<String, dynamic>?) ?? const {})['en'] as String? ?? iso,
      region: (j['region'] as String? ?? '').toUpperCase(),
      tales: j['tales'] as int? ?? 0,
      free: where['free'] as int? ?? 0,
      parts: {for (final e in ((where['parts'] as Map<String, dynamic>?) ?? const {}).entries) int.parse(e.key): e.value as int},
      coming: j['coming'] as int? ?? 0,
    );
  }
}

/// Every rendered scene of one country (`scenes.<CC>.<lang>.free`), free,
/// outside the binary: a tale's own pack keeps only what fits the per-tale
/// budget (Česko 1 408 of 16 145). No tales of its own — only pictures.
class ScenePacks {
  ScenePacks({required this.iso, required this.name, this.free});

  final String iso;
  final String name; // Czech: "Česko – všechny scény"
  final PackFile? free; // `tales` is 0, `images` the scene count

  static ScenePacks? fromJson(String iso, Map<String, dynamic> j) {
    final f = j['free'] as Map<String, dynamic>?;
    final names = (j['name'] as Map<String, dynamic>?) ?? const {};
    return ScenePacks(iso: iso, name: names['cs'] as String? ?? names['en'] as String? ?? iso, free: f == null ? null : _file(f));
  }
}

class PackFile {
  PackFile({required this.version, required this.size, required this.sha256, required this.tales, required this.file, this.images = 0});

  final int version;
  final int size;
  final String sha256;
  final int tales;
  final int images; // scene packs only
  final String file;
}

/// Dotted-number compare, missing parts are 0: `1.10.0` > `1.9.2`.
int compareVersions(String a, String b) {
  final pa = a.split('+').first.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  final pb = b.split('+').first.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  for (var i = 0; i < 3; i++) {
    final x = i < pa.length ? pa[i] : 0, y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}
