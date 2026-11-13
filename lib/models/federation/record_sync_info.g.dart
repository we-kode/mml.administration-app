// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_sync_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSyncInfo _$RecordSyncInfoFromJson(
  Map<String, dynamic> json,
) => RecordSyncInfo(
  links:
      (json['links'] as List<dynamic>?)
          ?.map((e) => RecordLink.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  problems:
      (json['problems'] as List<dynamic>?)
          ?.map((e) => RecordSyncProblem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  transfers:
      (json['transfers'] as List<dynamic>?)
          ?.map((e) => RecordSyncTransfer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  exclusions:
      (json['exclusions'] as List<dynamic>?)
          ?.map((e) => RecordExclusion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$RecordSyncInfoToJson(RecordSyncInfo instance) =>
    <String, dynamic>{
      'links': instance.links.map((e) => e.toJson()).toList(),
      'problems': instance.problems.map((e) => e.toJson()).toList(),
      'transfers': instance.transfers.map((e) => e.toJson()).toList(),
      'exclusions': instance.exclusions.map((e) => e.toJson()).toList(),
    };
