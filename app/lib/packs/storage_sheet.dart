import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pack_manifest.dart';
import 'pack_providers.dart';

const storageScenesOfferKey = Key('storage-scenes-offer');

/// "Stažené pohádky" — what's on the device and "Uvolnit místo" (§4):
/// free region and scene packs untouched for 30 days go, bought parts
/// stay (those are removed only one by one, and can always come back).
///
/// Below the list, the all-scenes packs the manifest offers and the device
/// doesn't have yet (Česko – všechny scény), with their download size:
/// they're pictures only, so there's no country on the globe to offer them
/// from, and this sheet is where downloaded content lives anyway.
class StorageSheet extends ConsumerWidget {
  const StorageSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(packRepositoryProvider).value;
    ref.watch(installedPacksRevisionProvider);
    if (repo == null) return const SizedBox.shrink();
    final packs = repo.installed();
    final manifest = ref.watch(packManifestProvider).value;
    final downloads = ref.watch(packDownloadsProvider);
    final sceneOffers = [for (final s in manifest?.scenes.values ?? const <ScenePacks>[]) if (!repo.hasScenes(s.iso)) s];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stažené pohádky', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF3E2723))),
            const SizedBox(height: 4),
            Text(
              packs.isEmpty ? 'Zatím nic — další pohádky se stáhnou z planety.' : '${packs.length} ${packs.length == 1 ? 'balíček' : packs.length < 5 ? 'balíčky' : 'balíčků'}, ${formatBytes(repo.bytesOnDisk())}',
              style: const TextStyle(color: Color(0x993E2723), fontSize: 13),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final p in packs)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(p.scenes != null
                          ? manifest?.scenes[p.scenes]?.name ?? 'Scény ${p.scenes}'
                          : '${manifest?.regions[p.region]?.name ?? p.country}${p.part == null ? '' : ' ${p.part}'}'),
                      subtitle: Text(formatBytes(p.size) + (p.tier == 'free' ? ' · zdarma' : ' · zakoupeno')),
                      trailing: IconButton(
                        tooltip: 'Smazat',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          repo.remove(p.id);
                          ref.read(installedPacksRevisionProvider.notifier).bump();
                        },
                      ),
                    ),
                  for (final s in sceneOffers)
                    ListTile(
                      key: storageScenesOfferKey,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.name),
                      subtitle: Text('Obrázek ke každému kroku vyprávění · ${formatBytes(s.free!.size)} · zdarma'),
                      trailing: switch (downloads[PackDownloads.scenesKey(s.iso)]) {
                        final progress? => SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, value: progress == 0 ? null : progress)),
                        null => IconButton(
                            tooltip: 'Stáhnout',
                            icon: const Icon(Icons.download_outlined),
                            onPressed: () async {
                              final err = await ref.read(packDownloadsProvider.notifier).installScenes(s.iso);
                              if (err != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                            },
                          ),
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
                onPressed: packs.isEmpty
                    ? null
                    : () {
                        final freed = repo.freeUpSpace();
                        ref.read(installedPacksRevisionProvider.notifier).bump();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(freed == 0 ? 'Všechno se používalo v posledních 30 dnech.' : 'Uvolněno ${formatBytes(freed)}.'),
                        ));
                      },
                child: const Text('Uvolnit místo (nepoužité 30 dní)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatBytes(int b) => b < 1024 * 1024 ? '${(b / 1024).ceil()} kB' : '${(b / (1024 * 1024)).toStringAsFixed(1).replaceAll('.', ',')} MB';
