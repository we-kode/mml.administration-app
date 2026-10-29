import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/view_models/sync/overview.dart';
import 'package:mml_admin/views/sync/unlink.dart';

/// View model of the dialog showing a partner and the rules which apply to
/// it.
class PeerViewModel extends ChangeNotifier {
  /// [FederationService] used to change the partner.
  final FederationService _service = FederationService.getInstance();

  /// The shown partner.
  final Peer peer;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Current build context.
  late BuildContext _context;

  /// The outgoing rules which apply to the partner.
  List<Rule> outgoingRules = [];

  /// The incoming rules which apply to the partner.
  List<Rule> incomingRules = [];

  /// Initializes the view model for the [peer].
  PeerViewModel(this.peer);

  /// Loads the rules which apply to the partner.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    try {
      var rules = await _service.getRules(peerId: peer.peerId);
      outgoingRules = rules
          .where((rule) => rule.direction == SyncDirection.outgoing)
          .toList();
      incomingRules = rules
          .where((rule) => rule.direction == SyncDirection.incoming)
          .toList();
    } on FederationException catch (e) {
      _showError(e);
    }

    return true;
  }

  /// Approves the registration request of the partner after the admin
  /// confirmed it and closes the dialog.
  Future<void> approve() async {
    var nav = Navigator.of(_context);
    if (!await showApproveDialog(
      _context,
      peer.instance,
      outgoingRules.length,
    )) {
      return;
    }

    showProgressIndicator();
    try {
      await _service.approve(peer.peerId);
      RouterService.getInstance().navigatorKey.currentState!.pop();
      nav.pop(true);
    } on FederationException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      _showError(e);
    } catch (_) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }

  /// Rejects the registration request of the partner after the admin
  /// confirmed it and closes the dialog.
  Future<void> reject() async {
    var nav = Navigator.of(_context);
    if (await rejectPeer(_context, peer)) {
      nav.pop(true);
    }
  }

  /// Changes the address of the partner to the one the admin enters and
  /// closes the dialog.
  Future<void> changeAddress() async {
    var nav = Navigator.of(_context);
    var baseUrl = await showAddressDialog(
      _context,
      peer.instance,
      peer.baseUrl,
    );
    if (baseUrl == null) {
      return;
    }

    showProgressIndicator();
    try {
      var changed = await _service.changeAddress(peer.peerId, baseUrl);
      RouterService.getInstance().navigatorKey.currentState!.pop();
      MessengerService.getInstance().showMessage(
        locales.addressChanged(changed.instance, changed.baseUrl),
      );
      nav.pop(true);
    } on FederationException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      _showError(e);
    } catch (_) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }

  /// Removes the registration of the partner and closes the dialog.
  Future<void> unlink() async {
    var nav = Navigator.of(_context);
    if (await unlinkPeer(_context, peer)) {
      nav.pop(true);
    }
  }

  void _showError(FederationException e) {
    MessengerService.getInstance().showMessage(e.message(locales));
  }
}
