import 'package:flutter/material.dart';
import 'package:mml_admin/components/info_tooltip.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

/// Shows the dialog to remove the registration of the partner [instance].
///
/// Returns whether the records should be removed too or null if the admin
/// cancels the operation.
Future<bool?> showUnlinkDialog(BuildContext context, String instance) {
  var locales = AppLocalizations.of(context)!;
  var deleteRecords = false;

  return showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(locales.unlinkTitle(instance)),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locales.unlinkInfo),
              verticalSpacer,
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: deleteRecords,
                onChanged: (value) =>
                    setState(() => deleteRecords = value ?? false),
                title: Row(
                  children: [
                    Flexible(child: Text(locales.unlinkDeleteRecords)),
                    InfoTooltip(
                      message: deleteRecords
                          ? locales.unlinkDeleteRecordsInfo(instance)
                          : locales.unlinkKeepRecordsInfo(instance),
                    ),
                  ],
                ),
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
            onPressed: () => Navigator.pop(context, deleteRecords),
            child: Text(locales.unlink),
          ),
        ],
      ),
    ),
  );
}

/// Asks the admin whether the registration of the partner [instance] should
/// be removed locally, because the partner cannot be informed.
Future<bool> showUnlinkLocallyDialog(
  BuildContext context,
  String instance,
  bool deleteRecords,
) async {
  var locales = AppLocalizations.of(context)!;
  var shouldForce = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(locales.federationRemoteUnreachable),
      content: SizedBox(
        width: 500,
        child: Text(
          deleteRecords
              ? locales.unlinkLocallyDeleteInfo(instance)
              : locales.unlinkLocallyInfo(instance),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(locales.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(locales.unlinkLocally),
        ),
      ],
    ),
  );

  return shouldForce ?? false;
}

/// Asks the admin whether the registration request of the partner [instance]
/// should be rejected.
Future<bool> showRejectDialog(BuildContext context, String instance) async {
  var locales = AppLocalizations.of(context)!;
  var shouldReject = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(locales.rejectTitle(instance)),
      content: SizedBox(width: 500, child: Text(locales.rejectInfo(instance))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(locales.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(locales.reject),
        ),
      ],
    ),
  );

  return shouldReject ?? false;
}

/// Asks the admin whether the registration request of the partner [instance]
/// should be approved. The dialog names the count of [outgoingRules], which
/// apply to the partner after the approval.
Future<bool> showApproveDialog(
  BuildContext context,
  String instance,
  int outgoingRules,
) async {
  var locales = AppLocalizations.of(context)!;
  var shouldApprove = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(locales.approveTitle(instance)),
      content: SizedBox(
        width: 500,
        child: Text(locales.approveInfo(instance, outgoingRules)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(locales.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(locales.approve),
        ),
      ],
    ),
  );

  return shouldApprove ?? false;
}
