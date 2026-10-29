import 'package:json_annotation/json_annotation.dart';

part 'audit_record.g.dart';

/// A record affected by an audit log entry.
@JsonSerializable()
class AuditRecord {
  /// Id of the record.
  final String recordId;

  /// Current title of the record.
  final String title;

  /// Initializes the model.
  AuditRecord({required this.recordId, required this.title});

  /// Converts a json object/map to the model.
  factory AuditRecord.fromJson(Map<String, dynamic> json) =>
      _$AuditRecordFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$AuditRecordToJson(this);
}
