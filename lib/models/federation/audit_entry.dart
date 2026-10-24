import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/rule.dart';

part 'audit_entry.g.dart';

/// Actions written to the federation audit log.
abstract class AuditAction {
  /// A registration was requested at a partner.
  static const int registrationRequested = 1;

  /// A registration request of a partner was received.
  static const int registrationReceived = 2;

  /// A registration was approved.
  static const int registrationApproved = 3;

  /// A registration was rejected.
  static const int registrationRejected = 4;

  /// A registration was removed.
  static const int unlinked = 5;

  /// The keys of an instance changed.
  static const int keysChanged = 6;

  /// A record was sent to a partner.
  static const int recordPushed = 7;

  /// A record was received from a partner.
  static const int recordReceived = 8;

  /// The metadata of a record was updated.
  static const int recordUpdated = 9;

  /// A record was deleted.
  static const int recordDeleted = 10;

  /// Records of a partner were removed.
  static const int recordsRemoved = 11;

  /// All actions.
  static const List<int> values = [
    registrationRequested,
    registrationReceived,
    registrationApproved,
    registrationRejected,
    unlinked,
    keysChanged,
    recordPushed,
    recordReceived,
    recordUpdated,
    recordDeleted,
    recordsRemoved,
  ];
}

/// Results of an audited action.
abstract class AuditStatus {
  /// The action succeeded.
  static const int success = 1;

  /// The action failed.
  static const int failed = 2;

  /// The action was skipped, e.g. because the record already exists.
  static const int skipped = 3;

  /// The action is scheduled and not finished yet.
  static const int pending = 4;

  /// All statuses.
  static const List<int> values = [pending, success, failed, skipped];
}

/// One entry of the federation audit log.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuditEntry {
  /// Id of the entry.
  final String entryId;

  /// Date when the entry was created.
  final DateTime timestamp;

  /// The action which was performed, see [AuditAction].
  final int action;

  /// The result of the action, see [AuditStatus].
  final int status;

  /// The instance the action originated from.
  final String source;

  /// The instance the action targeted.
  final String target;

  /// The direction of the action seen from this instance, see
  /// [SyncDirection].
  final int direction;

  /// The partner instance concerned by the action.
  final String instance;

  /// The id of the related transaction if available.
  final String? transactionId;

  /// The ids of the affected records.
  final List<String> recordIds;

  /// The affected records, which still exist, with their current titles.
  final List<AuditRecord> records;

  /// Additional information or the error message.
  final String? message;

  /// Initializes the model.
  AuditEntry({
    required this.entryId,
    required this.timestamp,
    required this.action,
    required this.status,
    required this.source,
    required this.target,
    this.direction = SyncDirection.incoming,
    this.instance = '',
    this.transactionId,
    this.recordIds = const [],
    this.records = const [],
    this.message,
  });

  /// Converts a json object/map to the model.
  factory AuditEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$AuditEntryToJson(this);

  /// Returns the translated name of the action.
  String actionName(AppLocalizations locales) {
    return AuditEntry.actionText(action, locales);
  }

  /// Returns the translated name of the status.
  String statusName(AppLocalizations locales) {
    return AuditEntry.statusText(status, locales);
  }

  /// Whether the admin should be notified about the entry: changes made by a
  /// partner and failed actions. Key changes are only logged.
  bool get isNotable =>
      status == AuditStatus.failed ||
      (direction == SyncDirection.incoming &&
          status == AuditStatus.success &&
          action != AuditAction.keysChanged);

  /// Returns the titles of the affected records in the order of [recordIds].
  /// Removed records are named with [removed].
  List<String> recordTitles(String removed) {
    var titles = {for (var record in records) record.recordId: record.title};
    return [for (var id in recordIds) titles[id] ?? removed];
  }

  /// Returns the translated name of the direction.
  String directionName(AppLocalizations locales) {
    return AuditEntry.directionText(direction, locales);
  }

  /// Returns the translated name of the [action], see [AuditAction].
  static String actionText(int action, AppLocalizations locales) {
    switch (action) {
      case AuditAction.registrationRequested:
        return locales.auditRegistrationRequested;
      case AuditAction.registrationReceived:
        return locales.auditRegistrationReceived;
      case AuditAction.registrationApproved:
        return locales.auditRegistrationApproved;
      case AuditAction.registrationRejected:
        return locales.auditRegistrationRejected;
      case AuditAction.unlinked:
        return locales.auditUnlinked;
      case AuditAction.keysChanged:
        return locales.auditKeysChanged;
      case AuditAction.recordPushed:
        return locales.auditRecordPushed;
      case AuditAction.recordReceived:
        return locales.auditRecordReceived;
      case AuditAction.recordUpdated:
        return locales.auditRecordUpdated;
      case AuditAction.recordDeleted:
        return locales.auditRecordDeleted;
      default:
        return locales.auditRecordsRemoved;
    }
  }

  /// Returns the translated name of the [status], see [AuditStatus].
  static String statusText(int status, AppLocalizations locales) {
    switch (status) {
      case AuditStatus.success:
        return locales.auditSuccess;
      case AuditStatus.failed:
        return locales.auditFailed;
      case AuditStatus.pending:
        return locales.auditPending;
      default:
        return locales.auditSkipped;
    }
  }

  /// Returns the translated name of the [direction], see [SyncDirection].
  static String directionText(int direction, AppLocalizations locales) {
    return direction == SyncDirection.outgoing
        ? locales.auditOutgoing
        : locales.auditIncoming;
  }
}

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

/// One page of audit log entries.
class AuditEntries {
  /// The loaded entries.
  final List<AuditEntry> items;

  /// The count of all entries matching the filter.
  final int totalCount;

  /// Initializes the page.
  AuditEntries(this.items, this.totalCount);
}
