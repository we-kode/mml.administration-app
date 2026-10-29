// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordLink _$RecordLinkFromJson(Map<String, dynamic> json) => RecordLink(
  direction: (json['direction'] as num).toInt(),
  syncedAt: DateTime.parse(json['syncedAt'] as String),
  instance: json['instance'] as String?,
);

Map<String, dynamic> _$RecordLinkToJson(RecordLink instance) =>
    <String, dynamic>{
      'instance': ?instance.instance,
      'direction': instance.direction,
      'syncedAt': instance.syncedAt.toIso8601String(),
    };
