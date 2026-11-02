// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  notificationId: json['notificationId'] as String?,
  title: json['title'] as String?,
  message: json['message'] as String?,
  severity: (json['severity'] as num?)?.toInt() ?? AnnouncementSeverity.info,
  validFrom: json['validFrom'] == null
      ? null
      : DateTime.parse(json['validFrom'] as String),
  validTo: json['validTo'] == null
      ? null
      : DateTime.parse(json['validTo'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  clientIds: (json['clientIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  groups: (json['groups'] as List<dynamic>?)
      ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
      .toList(),
  isDeletable: json['isDeletable'] as bool? ?? true,
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'isDeletable': instance.isDeletable,
      'notificationId': ?instance.notificationId,
      'title': ?instance.title,
      'message': ?instance.message,
      'severity': instance.severity,
      'validFrom': ?instance.validFrom?.toIso8601String(),
      'validTo': ?instance.validTo?.toIso8601String(),
      'clientIds': instance.clientIds,
      'groups': instance.groups.map((e) => e.toJson()).toList(),
    };
