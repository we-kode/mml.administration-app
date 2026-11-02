import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/oss_licenses.dart';
import 'package:mml_admin/views/settings/license.dart';

/// Dialog listing all packages used by the app, whose license can be opened.
class LicensesDialog extends StatelessWidget {
  /// Initializes the dialog.
  const LicensesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(locales.licenses),
      content: SizedBox(
        width: 500,
        height: 600,
        child: ListView.builder(
          itemCount: allDependencies.length,
          itemBuilder: (context, index) {
            var package = allDependencies[index];
            return ListTile(
              title: Text(package.name),
              subtitle: package.version != null ? Text(package.version!) : null,
              onTap: () => showDialog(
                context: context,
                builder: (context) => LicenseDialog(package: package),
              ),
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
