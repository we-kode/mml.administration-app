import 'package:mml_admin/models/federation/sync_direction.dart';

/// The progress of a transfer of a record between this instance and a
/// partner.
class TransferProgress {
  /// The audit log entry of the transfer if available.
  final String? entryId;

  /// The id of the local record if available.
  final String? recordId;

  /// The instance name of the partner.
  final String instance;

  /// Whether the record is sent or received, see [SyncDirection].
  final int direction;

  /// The number of transferred bytes.
  final int transferred;

  /// The size of the file in bytes.
  final int size;

  /// Initializes the model.
  const TransferProgress({
    required this.instance,
    required this.direction,
    required this.transferred,
    required this.size,
    this.entryId,
    this.recordId,
  });

  /// Converts a json object/map to the model.
  factory TransferProgress.fromJson(Map<String, dynamic> json) =>
      TransferProgress(
        entryId: json['entryId'] as String?,
        recordId: json['recordId'] as String?,
        instance: json['instance'] as String? ?? '',
        direction: json['direction'] as int? ?? 0,
        transferred: (json['transferred'] as num?)?.toInt() ?? 0,
        size: (json['size'] as num?)?.toInt() ?? 0,
      );

  /// The transferred part between 0 and 1.
  double get fraction => transferFraction(transferred, size) ?? 0;
}

/// Returns the transferred part between 0 and 1 of [transferred] bytes of
/// [size] bytes or null if the size is not known yet.
double? transferFraction(int? transferred, int? size) =>
    size == null || size <= 0 ? null : ((transferred ?? 0) / size).clamp(0, 1);
