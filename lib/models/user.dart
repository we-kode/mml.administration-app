import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model that holds all information of an admin user.
@JsonSerializable(includeIfNull: false)
class User {
  /// Id of the user.
  final int? id;

  /// Name of the user.
  final String? name;

  /// Bool that indicates, whether the user is confirmed or not.
  ///
  /// If not the user must change the password on next login.
  final bool? isConfirmed;

  /// Password of the user.
  ///
  /// Only to be set if a new user gets created.
  final String? password;

  /// Current password of the user.
  ///
  /// Only to be set if the users password should be changed.
  final String? oldPassword;

  /// New password of the user.
  ///
  /// Only to be set if the users password should be changed.
  final String? newPassword;

  /// Creates a new user instance with the given values.
  User({
    this.id,
    this.name,
    this.isConfirmed,
    this.password,
    this.oldPassword,
    this.newPassword,
  });

  /// Converts a json object/map to the user model.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts the current user model to a json object/map.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
