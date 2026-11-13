// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_sync_problem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
