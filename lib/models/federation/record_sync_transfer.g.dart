// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_sync_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordSyncTransfer _$RecordSyncTransferFromJson(Map<String, dynamic> json) =>
    RecordSyncTransfer(
      instance: json['instance'] as String,
      nextAttemptAt: DateTime.parse(json['nextAttemptAt'] as String),
      transferred: (json['transferred'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecordSyncTransferToJson(RecordSyncTransfer instance) =>
    <String, dynamic>{
      'instance': instance.instance,
      'transferred': instance.transferred,
      'size': ?instance.size,
      'nextAttemptAt': instance.nextAttemptAt.toIso8601String(),
    };
