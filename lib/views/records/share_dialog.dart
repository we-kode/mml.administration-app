import 'package:flutter/material.dart';
import 'package:mml_admin/components/share_options_fields.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/share_options.dart';

/// Dialog to configure a share link before it is created. Pops the chosen
/// [ShareOptions] and whether they are used as defaults from now on.
class ShareDialog extends StatefulWidget {
  /// The options the dialog starts with.
  final ShareOptions options;

  /// Initializes the dialog.
  const ShareDialog({super.key, required this.options});

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  bool _useAsDefault = false;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(locales.share),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShareOptionsFields(options: widget.options),
            verticalSpacer,
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(locales.shareUseAsDefault),
              value: _useAsDefault,
              onChanged: (value) => setState(() => _useAsDefault = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(locales.cancel),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, (widget.options, _useAsDefault)),
          child: Text(locales.share),
        ),
      ],
    );
  }
}
