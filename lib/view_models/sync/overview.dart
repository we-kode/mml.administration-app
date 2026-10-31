import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/peer_state.dart';
import 'package:mml_admin/models/federation/sync_result.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/federation_events.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/sync.dart';
import 'package:mml_admin/views/sync/unlink.dart';

/// Sections of the sync screen.
enum SyncSection {
  /// Open invitations for partners.
  invitations,

  /// Registered partner instances.
  peers,

  /// Rules of the synchronization.
  rules,

  /// Audit log of the synchronization.
  audit,
}

/// View model for the sync screen.
class SyncOverviewViewModel extends ChangeNotifier {
  /// Route for the sync screen.
  static String route = '/sync';

  /// Delay to collect partner events before the list is reloaded.
  static const Duration _peersReloadDelay = Duration(seconds: 2);

  /// Delay to collect audit events before new entries are announced.
  static const Duration _auditReloadDelay = Duration(seconds: 1);

  /// [FederationService] used to load the partners.
  final FederationService _service = FederationService.getInstance();

  /// The shown section, the invitations by default.
  final ValueNotifier<SyncSection> section = ValueNotifier(
    SyncSection.invitations,
  );

  /// The running instance or null if the server does not support the
  /// synchronization.
  final Future<String?> instance = SyncService.getInstance().get();

  /// Version of the partner list, which changes when partners changed on the
  /// server.
  final ValueNotifier<int> peersVersion = ValueNotifier(0);

  /// Version of the audit log, which changes when entries are added on the
  /// server. The list is not reloaded automatically.
  final ValueNotifier<int> auditVersion = ValueNotifier(0);

  StreamSubscription<FederationEvent>? _events;

  Timer? _peersReload;

  Timer? _auditReload;

  /// Initializes the view model and listens to federation events.
  SyncOverviewViewModel() {
    _events = FederationEventService.getInstance().events.listen((event) {
      if (event.type == FederationEventType.auditAdded) {
        _auditReload ??= Timer(_auditReloadDelay, () {
          _auditReload = null;
          auditVersion.value++;
        });
        return;
      }

      _peersReload ??= Timer(_peersReloadDelay, () {
        _peersReload = null;
        peersVersion.value++;
      });
    });
  }

  @override
  void dispose() {
    _events?.cancel();
    _peersReload?.cancel();
    _auditReload?.cancel();
    section.dispose();
    peersVersion.dispose();
    auditVersion.dispose();
    super.dispose();
  }

  /// Loads the partners with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    dynamic subfilter,
  }) {
    return _service.getPeers(filter, offset, take);
  }

  /// Removes the registration of the given [peers] after the admin confirmed
  /// it. Pending registration requests are rejected, so the partner is
  /// informed. Returns whether at least one registration was removed.
  Future<bool> unlink<T>(BuildContext context, List<T> peers) async {
    var removed = false;
    for (var peer in peers.whereType<Peer>()) {
      if (!context.mounted) {
        break;
      }

      removed =
          await (peer.isPendingApproval
              ? rejectPeer(context, peer)
              : unlinkPeer(context, peer)) ||
          removed;
    }

    return removed;
  }
}

/// Removes the registration of the [peer] after the admin confirmed it and
/// asks the admin again whether the registration should be removed locally if
/// the partner cannot be informed.
///
/// Returns whether the registration was removed.
Future<bool> unlinkPeer(BuildContext context, Peer peer) async {
  var locales = AppLocalizations.of(context)!;
  var service = FederationService.getInstance();
  var deleteRecords = await showUnlinkDialog(context, peer.instance);
  if (deleteRecords == null || !context.mounted) {
    return false;
  }

  var force = false;
  while (true) {
    showProgressIndicator();
    try {
      await service.unlink(
        peer.peerId,
        deleteRecords: deleteRecords,
        force: force,
      );
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return true;
    } on FederationException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      if (e.code != FederationErrors.remoteUnreachable ||
          force ||
          !context.mounted) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(e.message(locales));
        return e.code == FederationErrors.notFound;
      }

      force = await showUnlinkLocallyDialog(
        context,
        peer.instance,
        deleteRecords,
      );
      if (!force) {
        return false;
      }
    } catch (_) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return false;
    }
  }
}

/// Rejects the registration request of the [peer] after the admin confirmed
/// it. The partner is informed and the request is removed.
///
/// Returns whether the request was rejected.
Future<bool> rejectPeer(BuildContext context, Peer peer) async {
  var locales = AppLocalizations.of(context)!;
  if (!await showRejectDialog(context, peer.instance)) {
    return false;
  }

  showProgressIndicator();
  try {
    await FederationService.getInstance().reject(peer.peerId);
    return true;
  } on FederationException catch (e) {
    MessengerService.getInstance().showMessage(e.message(locales));
    return e.code == FederationErrors.notFound;
  } catch (_) {
    return false;
  } finally {
    RouterService.getInstance().navigatorKey.currentState!.pop();
  }
}

/// Sends the own records with the [recordIds] and within the [folders] to the
/// linked partners the admin selects and shows the result. Records with the
/// [recordIds] are sent even if their synchronization was revoked.
Future<void> synchronizeRecords(
  BuildContext context, {
  List<String> recordIds = const [],
  List<RecordFolder> folders = const [],
}) async {
  var locales = AppLocalizations.of(context)!;
  var selection = await _selectLinkedPeers(
    context,
    title: locales.synchronize,
    action: locales.synchronize,
  );
  if (selection == null) {
    return;
  }

  await _runSync(
    locales,
    () => FederationService.getInstance().synchronize(
      recordIds: recordIds,
      folders: folders,
      peerIds: selection.peerIds,
    ),
    (result) => locales.syncResult(result.queued, result.skipped),
  );
}

/// Revokes the synchronization of the own records with the [recordIds] and
/// within the [folders] with the linked partners the admin selects and shows
/// the result. Only the partners named in [instances] are offered if set.
Future<void> revokeRecords(
  BuildContext context, {
  List<String> recordIds = const [],
  List<RecordFolder> folders = const [],
  Set<String>? instances,
}) async {
  var locales = AppLocalizations.of(context)!;
  var selection = await _selectLinkedPeers(
    context,
    title: locales.revokeSync,
    action: locales.revokeSync,
    info: locales.revokeSyncInfo,
    instances: instances,
    confirm: true,
  );
  if (selection == null) {
    return;
  }

  await _runSync(
    locales,
    () => FederationService.getInstance().revoke(
      recordIds: recordIds,
      folders: folders,
      peerIds: selection.peerIds,
    ),
    (result) => locales.revokeResult(result.queued),
  );
}

/// Lets the admin select linked partners, which are named in [instances] if
/// set. The dialog is skipped for a single partner unless it must [confirm]
/// the action.
///
/// Returns the ids of the selected partners, null ids for all linked
/// partners, or null if the admin cancels the operation.
Future<({List<String>? peerIds})?> _selectLinkedPeers(
  BuildContext context, {
  required String title,
  required String action,
  String? info,
  Set<String>? instances,
  bool confirm = false,
}) async {
  List<Peer> peers;
  try {
    peers = (await FederationService.getInstance().getPeers(null, 0, -1))
        .whereType<Peer>()
        .where((peer) => peer.state == PeerState.linked)
        .where((peer) => instances?.contains(peer.instance) ?? true)
        .toList();
  } catch (_) {
    // Errors are shown by the api service.
    return null;
  }

  if (!context.mounted || (instances != null && peers.isEmpty)) {
    return null;
  }

  if (peers.length <= (confirm ? 0 : 1)) {
    return (peerIds: null);
  }

  var selected = await showPeerSelectionDialog(
    context,
    peers,
    title: title,
    action: action,
    info: info,
  );
  if (selected == null) {
    return null;
  }

  return (
    peerIds: instances == null && selected.length == peers.length
        ? null
        : selected,
  );
}

Future<void> _runSync(
  AppLocalizations locales,
  Future<SyncResult> Function() action,
  String Function(SyncResult result) message,
) async {
  var messenger = MessengerService.getInstance();
  showProgressIndicator();
  try {
    messenger.showMessage(message(await action()));
  } on FederationException catch (e) {
    messenger.showMessage(e.message(locales));
  } catch (_) {
    // Other errors are shown by the api service.
  } finally {
    RouterService.getInstance().navigatorKey.currentState!.pop();
  }
}
