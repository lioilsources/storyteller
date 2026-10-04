/// `manifest.json` schema 3 (STORYTELLER_MONETIZATION_PLAN.md §6, §11), as
/// `rag.pack_builder` writes it and GitHub Pages serves it.
///
/// Free tales ship per continent (`continents`), paid ones per country
/// (`countries`). A `bundled` continent (Evropa) is in the app binary and
/// never offered for download.
///
/// Paid packs carry no URL on purpose: the client composes it from
/// `base_urls.paid` only after the store says the user owns the product.
class PackManifest {
  PackManifest({required this.schema, required this.lang, required this.minAppVersion, required this.freeBase, required this.paidBase, required this.continents, required this.countries});

  /// Newest schema this client understands; a newer manifest is ignored
  /// (the cached or bundled one stays in use) rather than misread.
  /// 3: free packs per continent instead of per country.
  static const supportedSchema = 3;

  final int schema;
  final String lang;
  final String minAppVersion;
  final String freeBase;
  final String paidBase;
  final Map<String, ContinentPacks> continents; // keyed by upper-case code: EU, AF, AS, NA, SA, OC
  final Map<String, CountryPacks> countries; // keyed by upper-case ISO, like the rest of the app

  /// The continent whose free pack carries [iso]'s free tales, or null
  /// when the manifest has no free tales from there.
  ContinentPacks? continentOf(String iso) {
    final code = countries[iso]?.continent;
    final c = code == null ? null : continents[code];
    if (c != null && c.countries.contains(iso)) return c;
    for (final c in continents.values) {
      if (c.countries.contains(iso)) return c;
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
      continents: {
        for (final e in ((j['continents'] as Map<String, dynamic>?) ?? const {}).entries) e.key.toUpperCase(): ContinentPacks.fromJson(e.key.toUpperCase(), e.value as Map<String, dynamic>),
      },
      countries: {
        for (final e in ((j['countries'] as Map<String, dynamic>?) ?? const {}).entries) e.key.toUpperCase(): CountryPacks.fromJson(e.key.toUpperCase(), e.value as Map<String, dynamic>),
      },
    );
  }
}

/// Free tales of every country of one continent, in one pack
/// (`continent.<K>.<lang>.free`).
class ContinentPacks {
  ContinentPacks({required this.code, required this.name, required this.bundled, required this.countries, this.free});

  final String code;
  final String name; // Czech, nominative: "Afrika"
  final bool bundled; // in the app binary (Evropa): never downloaded
  final Set<String> countries;
  final PackFile? free;

  factory ContinentPacks.fromJson(String code, Map<String, dynamic> j) {
    final f = j['free'] as Map<String, dynamic>?;
    final names = (j['name'] as Map<String, dynamic>?) ?? const {};
    return ContinentPacks(
      code: code,
      name: names['cs'] as String? ?? names['en'] as String? ?? code,
      bundled: j['bundled'] as bool? ?? false,
      countries: {for (final c in (j['countries'] as List? ?? const [])) (c as String).toUpperCase()},
      free: f == null ? null : PackFile(version: f['version'] as int, size: f['size'] as int, sha256: f['sha256'] as String, tales: f['tales'] as int? ?? 0, file: f['file'] as String),
    );
  }
}

class CountryPacks {
  CountryPacks({required this.iso, required this.name, this.continent, this.freeTales = 0, this.paid});

  final String iso;
  final String name;
  final String? continent; // upper-case continent code
  final int freeTales; // in the continent's free pack
  final PaidPack? paid;

  factory CountryPacks.fromJson(String iso, Map<String, dynamic> j) {
    final p = j['paid'] as Map<String, dynamic>?;
    return CountryPacks(
      iso: iso,
      name: ((j['name'] as Map<String, dynamic>?) ?? const {})['en'] as String? ?? iso,
      continent: (j['continent'] as String?)?.toUpperCase(),
      freeTales: j['free_tales'] as int? ?? 0,
      paid: p == null
          ? null
          : PaidPack(
              productId: p['product_id'] as String,
              version: p['version'] as int,
              tales: p['tales'] as int? ?? 0,
              tiers: {
                for (final e in (p['tiers'] as Map<String, dynamic>).entries)
                  e.key: PackFile(version: p['version'] as int, size: (e.value as Map)['size'] as int, sha256: (e.value as Map)['sha256'] as String, tales: p['tales'] as int? ?? 0, file: '${iso.toLowerCase()}-${e.key}.zip'),
              },
            ),
    );
  }
}

class PackFile {
  PackFile({required this.version, required this.size, required this.sha256, required this.tales, required this.file});

  final int version;
  final int size;
  final String sha256;
  final int tales;
  final String file;
}

class PaidPack {
  PaidPack({required this.productId, required this.version, required this.tales, required this.tiers});

  final String productId;
  final int version;
  final int tales;
  final Map<String, PackFile> tiers; // lite (full comes in phase 4)

  /// `<paid base>pack-<cc>-v<version>/<cc>-<tier>.zip` — §6.
  String url(String paidBase, String iso, String tier) => '${paidBase}pack-${iso.toLowerCase()}-v$version/${iso.toLowerCase()}-$tier.zip';
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
