// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSyncInfo _$RecordSyncInfoFromJson(Map<String, dynamic> json) =>
    RecordSyncInfo(
      links:
          (json['links'] as List<dynamic>?)
              ?.map((e) => RecordLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      problems:
          (json['problems'] as List<dynamic>?)
              ?.map(
                (e) => RecordSyncProblem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RecordSyncInfoToJson(RecordSyncInfo instance) =>
    <String, dynamic>{
      'links': instance.links.map((e) => e.toJson()).toList(),
      'problems': instance.problems.map((e) => e.toJson()).toList(),
    };

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

RecordSyncProblem _$RecordSyncProblemFromJson(Map<String, dynamic> json) =>
    RecordSyncProblem(
      instance: json['instance'] as String,
      error: json['error'] as String?,
      failed: json['failed'] as bool? ?? false,
      nextAttemptAt: json['nextAttemptAt'] == null
          ? null
          : DateTime.parse(json['nextAttemptAt'] as String),
    );

Map<String, dynamic> _$RecordSyncProblemToJson(RecordSyncProblem instance) =>
    <String, dynamic>{
      'instance': instance.instance,
      'error': ?instance.error,
      'failed': instance.failed,
      'nextAttemptAt': ?instance.nextAttemptAt?.toIso8601String(),
    };
