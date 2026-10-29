import 'package:json_annotation/json_annotation.dart';

part 'record_sync_transfer.g.dart';

/// A waiting or running transfer of a record to a partner.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordSyncTransfer {
  /// The instance name of the partner.
  final String instance;

  /// The number of bytes the partner received so far.
  final int transferred;

  /// The size of the file in bytes or null if the transfer did not start
  /// yet.
  final int? size;

  /// Date of the next attempt.
  final DateTime nextAttemptAt;

  /// Initializes the model.
  RecordSyncTransfer({
    required this.instance,
    required this.nextAttemptAt,
    this.transferred = 0,
    this.size,
  });

  /// Converts a json object/map to the model.
  factory RecordSyncTransfer.fromJson(Map<String, dynamic> json) =>
      _$RecordSyncTransferFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordSyncTransferToJson(this);

  /// Returns a copy with the given [transferred] bytes and [size].
  RecordSyncTransfer withProgress(int transferred, int size) =>
      RecordSyncTransfer(
        instance: instance,
        nextAttemptAt: nextAttemptAt,
        transferred: transferred,
        size: size,
      );
}
