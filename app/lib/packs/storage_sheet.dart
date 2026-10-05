import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pack_providers.dart';

/// "Stažené pohádky" — what's on the device and "Uvolnit místo" (§4):
/// free continent packs untouched for 30 days go, bought country packs
/// stay (those are removed only one by one, and can always come back).
class StorageSheet extends ConsumerWidget {
  const StorageSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(packRepositoryProvider).value;
    ref.watch(installedPacksRevisionProvider);
    if (repo == null) return const SizedBox.shrink();
    final packs = repo.installed();
    final manifest = ref.watch(packManifestProvider).value;
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
              packs.isEmpty ? 'Zatím nic — pohádky dalších kontinentů se stáhnou z planety.' : '${packs.length} ${packs.length == 1 ? 'balíček' : packs.length < 5 ? 'balíčky' : 'balíčků'}, ${formatBytes(repo.bytesOnDisk())}',
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
                      title: Text(p.continent != null ? manifest?.continents[p.continent]?.name ?? p.continent! : manifest?.countries[p.country]?.name ?? p.country),
                      subtitle: Text(formatBytes(p.size) + (p.continent != null ? ' · zdarma' : ' · zakoupeno')),
                      trailing: IconButton(
                        tooltip: 'Smazat',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          if (p.continent case final k?) {
                            repo.removeContinent(k);
                          } else {
                            repo.remove(p.country);
                          }
                          ref.read(installedPacksRevisionProvider.notifier).bump();
                        },
                      ),
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
