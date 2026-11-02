import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/oss_licenses.dart';

/// Dialog showing the license text of a package.
class LicenseDialog extends StatelessWidget {
  /// The package whose license is shown.
  final Package package;

  /// Initializes the dialog.
  const LicenseDialog({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(package.name),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: SelectableText(package.license ?? ''),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}
