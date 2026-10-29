import 'package:json_annotation/json_annotation.dart';

part 'record_exclusion.g.dart';

/// A partner an own record is excluded from the synchronization with.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordExclusion {
  /// Id of the partner.
  final String peerId;

  /// The instance name of the partner.
  final String instance;

  /// Date when the synchronization was revoked.
  final DateTime createdAt;

  /// Initializes the model.
  RecordExclusion({
    required this.peerId,
    required this.instance,
    required this.createdAt,
  });

  /// Converts a json object/map to the model.
  factory RecordExclusion.fromJson(Map<String, dynamic> json) =>
      _$RecordExclusionFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordExclusionToJson(this);
}
