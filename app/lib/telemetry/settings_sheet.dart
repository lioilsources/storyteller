import 'package:flutter/material.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';

const settingsStatsSwitchKey = Key('settings-stats-switch');

/// "Nastavení" from the globe: for now only the switch for anonymous usage
/// statistics (docs/telemetry.md). The globe offers the sheet only when
/// [Telemetry.isConfigured] — a build without a key measures nothing and
/// has nothing to switch off.
class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nastavení', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF3E2723))),
            const SizedBox(height: 8),
            SwitchListTile(
              key: settingsStatsSwitchKey,
              contentPadding: EdgeInsets.zero,
              title: const Text('Anonymní statistiky používání'),
              subtitle: const Text(
                'Pomáhají zjistit, co v aplikaci funguje a kde se zasekává. '
                'Nic o pohádkách, o tobě ani o dítěti, žádné jméno ani text.',
              ),
              value: Telemetry.isEnabled,
              onChanged: (on) async {
                await Telemetry.setEnabled(on);
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
