import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/invitation.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';

/// View model of the list of open invitations.
class InvitationsViewModel extends ChangeNotifier {
  /// [FederationService] used to manage the invitations.
  final FederationService _service = FederationService.getInstance();

  /// Loads the open invitations.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    dynamic subfilter,
  }) {
    return _service.getInvitations();
  }

  /// Creates a new invitation, which stays valid for [validityHours]. Returns
  /// the invitation containing the code or null on errors.
  Future<Invitation?> create(BuildContext context, int validityHours) async {
    var locales = AppLocalizations.of(context)!;
    showProgressIndicator();
    try {
      var invitation = await _service.createInvitation(validityHours);
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return invitation;
    } on FederationException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      MessengerService.getInstance().showMessage(e.message(locales));
    } catch (_) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }

    return null;
  }

  /// Revokes the given [invitations] after the admin confirmed it.
  Future<bool> delete<T>(BuildContext context, List<T> invitations) async {
    var shouldDelete = await showDeleteDialog(context);
    if (!shouldDelete) {
      return false;
    }

    showProgressIndicator();
    try {
      await _service.deleteInvitations(
        invitations.whereType<Invitation>().map((e) => e.invitationId).toList(),
      );
      return true;
    } catch (_) {
      // Do not reload list on error!
      return false;
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }
}
