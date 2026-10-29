import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/federation.dart';

/// Translates the errors of the federation endpoints.
extension FederationErrorMessage on FederationException {
  /// Returns the translated message of the error.
  String message(AppLocalizations locales) {
    switch (code) {
      case FederationErrors.disabled:
        return locales.federationDisabled;
      case FederationErrors.invalidUrl:
        return locales.federationInvalidUrl;
      case FederationErrors.remoteUnreachable:
        return locales.federationRemoteUnreachable;
      case FederationErrors.remoteRejected:
        return locales.federationRemoteRejected;
      case FederationErrors.invalidDiscovery:
        return locales.federationInvalidDiscovery;
      case FederationErrors.instanceConflict:
        return locales.federationInstanceConflict;
      case FederationErrors.invalidState:
        return locales.federationInvalidState;
      case FederationErrors.invalidInvitation:
        return locales.federationInvalidInvitation;
      case FederationErrors.notFound:
        return locales.notFound;
      case FederationErrors.invalidPeer:
        return locales.federationInvalidPeer;
      case FederationErrors.unknownKeys:
        return locales.federationUnknownKeys;
      default:
        return locales.unexpectedError('${code ?? statusCode ?? ''}');
    }
  }
}
