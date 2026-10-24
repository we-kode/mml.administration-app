import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/model_base.dart';

part 'record_sync.g.dart';

/// Synchronization states of a record.
abstract class RecordSyncState {
  /// An own record, which is not sent to any partner.
  static const int none = 0;

  /// The record was received from a partner.
  static const int received = 1;

  /// The record was sent to at least one partner.
  static const int sent = 2;

  /// An operation to synchronize the record with a partner failed.
  static const int problem = 3;

  /// All states in the order they are offered in filters.
  static const List<int> all = [received, sent, problem, none];
}

/// A synchronization state which can be selected in filters.
class SyncStateOption extends ModelBase {
  /// The state, see [RecordSyncState].
  final int state;

  /// Locales used for the name of the state.
  final AppLocalizations locales;

  /// Initializes the option.
  SyncStateOption(this.state, this.locales);

  @override
  String getDisplayDescription() {
    switch (state) {
      case RecordSyncState.received:
        return locales.syncStateReceived;
      case RecordSyncState.sent:
        return locales.syncStateSent;
      case RecordSyncState.problem:
        return locales.syncStateProblem;
      default:
        return locales.syncStateNone;
    }
  }

  @override
  dynamic getIdentifier() {
    return state;
  }
}

/// The synchronization details of one record.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordSyncInfo {
  /// The partners the record was sent to or received from.
  final List<RecordLink> links;

  /// The operations of the record which failed or are retried after an
  /// error.
  final List<RecordSyncProblem> problems;

  /// Initializes the model.
  RecordSyncInfo({this.links = const [], this.problems = const []});

  /// Converts a json object/map to the model.
  factory RecordSyncInfo.fromJson(Map<String, dynamic> json) =>
      _$RecordSyncInfoFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordSyncInfoToJson(this);
}

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
