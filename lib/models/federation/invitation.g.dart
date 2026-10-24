// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invitation _$InvitationFromJson(Map<String, dynamic> json) => Invitation(
  invitationId: json['invitationId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  code: json['code'] as String?,
  baseUrl: json['baseUrl'] as String?,
  isDeletable: json['isDeletable'] as bool? ?? true,
);

Map<String, dynamic> _$InvitationToJson(Invitation instance) =>
    <String, dynamic>{
      'isDeletable': instance.isDeletable,
      'invitationId': instance.invitationId,
      'code': ?instance.code,
      'baseUrl': ?instance.baseUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
