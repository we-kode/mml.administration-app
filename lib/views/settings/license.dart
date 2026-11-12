import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

/// Dialog showing the license texts of a package.
class LicenseDialog extends StatelessWidget {
  /// The name of the package whose licenses are shown.
  final String package;

  /// The license entries registered for the package.
  final List<LicenseEntry> entries;

  /// Initializes the dialog.
  const LicenseDialog({
    super.key,
    required this.package,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(package),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                if (i > 0) const Divider(height: 32),
                SelectableText(
                  entries[i].paragraphs
                      .map((p) => '${'  ' * p.indent}${p.text}')
                      .join('\n\n'),
                ),
              ],
            ],
          ),
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
