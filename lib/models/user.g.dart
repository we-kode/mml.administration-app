// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isConfirmed: json['isConfirmed'] as bool?,
      password: json['password'] as String?,
      oldPassword: json['oldPassword'] as String?,
      newPassword: json['newPassword'] as String?,
      isDeletable: json['isDeletable'] as bool? ?? true,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('isConfirmed', instance.isConfirmed);
  writeNotNull('password', instance.password);
  writeNotNull('oldPassword', instance.oldPassword);
  writeNotNull('newPassword', instance.newPassword);
  return val;
}
