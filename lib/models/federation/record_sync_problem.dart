import 'package:json_annotation/json_annotation.dart';

part 'record_sync_problem.g.dart';

/// A failed operation to synchronize a record with a partner.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordSyncProblem {
  /// The instance name of the partner.
  final String instance;

  /// The last error message.
  final String? error;

  /// Indicates whether the operation failed finally. Otherwise it is
  /// retried.
  final bool failed;

  /// Date of the next attempt, if the operation is retried.
  final DateTime? nextAttemptAt;

  /// Initializes the model.
  RecordSyncProblem({
    required this.instance,
    this.error,
    this.failed = false,
    this.nextAttemptAt,
  });

  /// Converts a json object/map to the model.
  factory RecordSyncProblem.fromJson(Map<String, dynamic> json) =>
      _$RecordSyncProblemFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordSyncProblemToJson(this);
}
