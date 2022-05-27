import 'package:mml_admin/models/user.dart';

/// Arguments which are passed to the [ChangePasswordScreen].
class ChangePasswordArguments {
  /// Actual [User] the password will be changed for.
  final User user;

  /// True, if the [ChangePasswordScreen] is called manually by a user.
  final bool isManualTriggered;

  /// Initilaizes class with [User] and if triggered by user manually.
  ///
  /// Manually triggered flag defaults to false.
  ChangePasswordArguments(this.user, {this.isManualTriggered = false});
}
