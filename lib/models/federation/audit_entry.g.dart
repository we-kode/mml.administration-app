// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntry _$AuditEntryFromJson(Map<String, dynamic> json) => AuditEntry(
  entryId: json['entryId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  action: (json['action'] as num).toInt(),
  status: (json['status'] as num).toInt(),
  source: json['source'] as String,
  target: json['target'] as String,
  direction: (json['direction'] as num?)?.toInt() ?? SyncDirection.incoming,
  instance: json['instance'] as String? ?? '',
  transactionId: json['transactionId'] as String?,
  recordIds:
      (json['recordIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => AuditRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  message: json['message'] as String?,
);

Map<String, dynamic> _$AuditEntryToJson(AuditEntry instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'timestamp': instance.timestamp.toIso8601String(),
      'action': instance.action,
      'status': instance.status,
      'source': instance.source,
      'target': instance.target,
      'direction': instance.direction,
      'instance': instance.instance,
      'transactionId': ?instance.transactionId,
      'recordIds': instance.recordIds,
      'records': instance.records.map((e) => e.toJson()).toList(),
      'message': ?instance.message,
    };

AuditRecord _$AuditRecordFromJson(Map<String, dynamic> json) => AuditRecord(
  recordId: json['recordId'] as String,
  title: json['title'] as String,
);

Map<String, dynamic> _$AuditRecordToJson(AuditRecord instance) =>
    <String, dynamic>{'recordId': instance.recordId, 'title': instance.title};
