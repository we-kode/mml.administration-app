import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/federation_events.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';
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
