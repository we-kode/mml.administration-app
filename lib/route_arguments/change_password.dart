import 'package:mml_admin/models/user.dart';

class ChangePasswordArguments {
  final User user;
  final bool isManualTriggered;

  ChangePasswordArguments(this.user, {this.isManualTriggered = false});
}