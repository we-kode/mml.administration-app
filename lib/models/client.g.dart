// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
  clientId: json['clientId'] as String?,
  displayName: json['displayName'] as String?,
  deviceIdentifier: json['deviceIdentifier'] as String?,
  lastTokenRefreshDate: json['lastTokenRefreshDate'] == null
      ? null
      : DateTime.parse(json['lastTokenRefreshDate'] as String),
  isDeletable: json['isDeletable'] as bool? ?? true,
  groups: (json['groups'] as List<dynamic>?)
      ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
  'isDeletable': instance.isDeletable,
  'clientId': ?instance.clientId,
  'displayName': ?instance.displayName,
  'deviceIdentifier': ?instance.deviceIdentifier,
  'lastTokenRefreshDate': ?instance.lastTokenRefreshDate?.toIso8601String(),
  'groups': instance.groups.map((e) => e.toJson()).toList(),
};
