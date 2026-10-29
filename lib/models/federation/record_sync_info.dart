import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/federation/record_exclusion.dart';
import 'package:mml_admin/models/federation/record_link.dart';
import 'package:mml_admin/models/federation/record_sync_problem.dart';
import 'package:mml_admin/models/federation/record_sync_state.dart';
import 'package:mml_admin/models/federation/record_sync_transfer.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';

part 'record_sync_info.g.dart';

/// The synchronization details of one record.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordSyncInfo {
  /// The partners the record was sent to or received from.
  final List<RecordLink> links;

  /// The operations of the record which failed or are retried after an
  /// error.
  final List<RecordSyncProblem> problems;

  /// The transfers of the record to partners which are waiting or running.
  final List<RecordSyncTransfer> transfers;

  /// The partners the synchronization of the record was revoked for.
  final List<RecordExclusion> exclusions;

  /// Initializes the model.
  RecordSyncInfo({
    this.links = const [],
    this.problems = const [],
    this.transfers = const [],
    this.exclusions = const [],
  });

  /// Converts a json object/map to the model.
  factory RecordSyncInfo.fromJson(Map<String, dynamic> json) =>
      _$RecordSyncInfoFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordSyncInfoToJson(this);

  /// The synchronization state of an own record with these details, see
  /// [RecordSyncState], evaluated in the same order as on the server.
  int get ownState => problems.isNotEmpty
      ? RecordSyncState.problem
      : transfers.isNotEmpty
      ? RecordSyncState.pending
      : links.any((link) => link.direction == SyncDirection.outgoing)
      ? RecordSyncState.sent
      : RecordSyncState.none;
}
