import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class User {
  final int? id;
  final String? name;
  final bool? isConfirmed;
  final String? password;
  final String? oldPassword;
  final String? newPassword;

  User({
    this.id,
    this.name,
    this.isConfirmed,
    this.password,
    this.oldPassword,
    this.newPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
