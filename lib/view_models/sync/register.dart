import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';

/// View model of the dialog to request the registration at a partner.
class PeerRegisterViewModel extends ChangeNotifier {
  /// Pattern of a valid invitation code.
  static final RegExp _codePattern = RegExp(
    r'^[0-9A-Za-z]{5}(-?[0-9A-Za-z]{5}){3}$',
  );

  /// [FederationService] used to request the registration.
  final FederationService _service = FederationService.getInstance();

  /// Key of the form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// The base url of the partner.
  String baseUrl = '';

  /// The invitation code created by the admin of the partner.
  String invitationCode = '';

  /// Validates the [url] of the partner.
  String? validateUrl(String? url, AppLocalizations locales) {
    return validatePeerUrl(url, locales);
  }

  /// Validates the invitation [code].
  String? validateCode(String? code, AppLocalizations locales) {
    return _codePattern.hasMatch(code?.trim() ?? '')
        ? null
        : locales.federationInvalidInvitation;
  }

  /// Requests the registration and closes the dialog on success.
  Future<void> request(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    var nav = Navigator.of(context);
    var locales = AppLocalizations.of(context)!;
    showProgressIndicator();
    try {
      await _service.requestRegistration(
        baseUrl.trim(),
        invitationCode.trim().toUpperCase(),
      );
      RouterService.getInstance().navigatorKey.currentState!.pop();
      nav.pop(true);
    } on FederationException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      MessengerService.getInstance().showMessage(e.message(locales));
    } catch (_) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }
}

/// Validates the [url] of a partner, which must be an https url, and returns
/// an error message or null if the [url] is valid.
String? validatePeerUrl(String? url, AppLocalizations locales) {
  var uri = Uri.tryParse(url?.trim() ?? '');
  return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
      ? null
      : locales.federationInvalidUrl;
}
