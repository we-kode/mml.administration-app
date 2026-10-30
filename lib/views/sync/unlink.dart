import 'package:flutter/material.dart';
import 'package:mml_admin/components/info_tooltip.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/view_models/sync/register.dart';

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

/// Lets the admin select the partners of the [peers] an action is applied
/// to. All partners are selected initially. The dialog is named with the
/// [title] and confirmed with the [action].
///
/// Returns the ids of the selected partners or null if the admin cancels the
/// operation.
Future<List<String>?> showPeerSelectionDialog(
  BuildContext context,
  List<Peer> peers, {
  required String title,
  required String action,
  String? info,
}) {
  var locales = AppLocalizations.of(context)!;
  var selected = {for (var peer in peers) peer.peerId};

  return showDialog<List<String>>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (info != null) ...[Text(info), verticalSpacer],
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  tristate: true,
                  value: selected.length == peers.length
                      ? true
                      : selected.isEmpty
                      ? false
                      : null,
                  onChanged: (_) => setState(
                    () => selected.length == peers.length
                        ? selected.clear()
                        : selected.addAll(peers.map((p) => p.peerId)),
                  ),
                  title: Text(locales.allInstances),
                ),
                for (var peer in peers)
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.only(left: 20),
                    value: selected.contains(peer.peerId),
                    onChanged: (value) => setState(
                      () => value ?? false
                          ? selected.add(peer.peerId)
                          : selected.remove(peer.peerId),
                    ),
                    title: Text(peer.instance),
                    subtitle: Text(peer.baseUrl),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locales.cancel),
          ),
          TextButton(
            onPressed: selected.isEmpty
                ? null
                : () => Navigator.pop(context, selected.toList()),
            child: Text(action),
          ),
        ],
      ),
    ),
  );
}

/// Shows the dialog to change the address of the partner [instance], which
/// is reachable at the [baseUrl] so far.
///
/// Returns the new address or null if the admin cancels the operation.
Future<String?> showAddressDialog(
  BuildContext context,
  String instance,
  String baseUrl,
) {
  var locales = AppLocalizations.of(context)!;
  var formKey = GlobalKey<FormState>();
  var url = baseUrl;

  void submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      Navigator.pop(context, url);
    }
  }

  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(locales.changeAddressTitle(instance)),
      content: SizedBox(
        width: 500,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locales.changeAddressInfo(instance)),
              verticalSpacer,
              TextFormField(
                onFieldSubmitted: (_) => submit(context),
                initialValue: baseUrl,
                decoration: InputDecoration(labelText: locales.peerUrl),
                onChanged: (value) => url = value.trim(),
                validator: (value) => validatePeerUrl(value, locales),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(locales.cancel),
        ),
        TextButton(
          onPressed: () => submit(context),
          child: Text(locales.save),
        ),
      ],
    ),
  );
}
