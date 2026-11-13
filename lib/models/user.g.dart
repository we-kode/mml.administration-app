// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  isConfirmed: json['isConfirmed'] as bool?,
  password: json['password'] as String?,
  oldPassword: json['oldPassword'] as String?,
  newPassword: json['newPassword'] as String?,
  isDeletable: json['isDeletable'] as bool? ?? true,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'isDeletable': instance.isDeletable,
  'id': ?instance.id,
  'name': ?instance.name,
  'isConfirmed': ?instance.isConfirmed,
  'password': ?instance.password,
  'oldPassword': ?instance.oldPassword,
  'newPassword': ?instance.newPassword,
};
