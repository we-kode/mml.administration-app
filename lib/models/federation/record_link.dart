import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';

part 'record_link.g.dart';

/// A partner a record was sent to or received from.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordLink {
  /// The instance name of the partner.
  final String? instance;

  /// The direction the record was synchronized, see [SyncDirection].
  final int direction;

  /// Date when the record was synchronized.
  final DateTime syncedAt;

  /// Initializes the model.
  RecordLink({required this.direction, required this.syncedAt, this.instance});

  /// Converts a json object/map to the model.
  factory RecordLink.fromJson(Map<String, dynamic> json) =>
      _$RecordLinkFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordLinkToJson(this);
}
