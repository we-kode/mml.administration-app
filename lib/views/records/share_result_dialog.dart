import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/share_response.dart';
import 'package:mml_admin/services/messenger.dart';

/// Dialog that shows the created share link and copies it to the clipboard.
class ShareResultDialog extends StatelessWidget {
  /// The created link.
  final ShareResponse response;

  /// Initializes the dialog.
  const ShareResultDialog({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(locales.shareLinkCreated),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectableText(response.url),
            verticalSpacer,
            Text(
              locales.shareLinkHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: response.url));
            MessengerService.getInstance().showMessage(locales.linkCopied);
          },
          child: Text(locales.copy),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(locales.close),
        ),
      ],
    );
  }
}
