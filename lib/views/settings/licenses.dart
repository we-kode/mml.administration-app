import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/views/settings/license.dart';

/// Dialog listing all packages registered in the [LicenseRegistry], whose
/// license can be opened.
class LicensesDialog extends StatefulWidget {
  /// Initializes the dialog.
  const LicensesDialog({super.key});

  @override
  State<LicensesDialog> createState() => _LicensesDialogState();
}

class _LicensesDialogState extends State<LicensesDialog> {
  late final Future<Map<String, List<LicenseEntry>>> _licenses = _load();

  static Future<Map<String, List<LicenseEntry>>> _load() async {
    final licenses = SplayTreeMap<String, List<LicenseEntry>>();
    await for (final entry in LicenseRegistry.licenses) {
      for (final package in entry.packages) {
        (licenses[package] ??= []).add(entry);
      }
    }
    return licenses;
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(locales.licenses),
      content: SizedBox(
        width: 500,
        height: 600,
        child: FutureBuilder(
          future: _licenses,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var packages = snapshot.data!.entries.toList();
            return ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                var package = packages[index];
                return ListTile(
                  title: Text(package.key),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => LicenseDialog(
                      package: package.key,
                      entries: package.value,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(locales.close),
        ),
      ],
    );
  }
}
