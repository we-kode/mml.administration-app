import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/audit_action.dart';
import 'package:mml_admin/models/federation/audit_record.dart';
import 'package:mml_admin/models/federation/audit_status.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';

part 'audit_entry.g.dart';

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

  /// The number of transferred bytes if the entry is a running transfer.
  final int? transferred;

  /// The size of the file in bytes if the entry is a running transfer.
  final int? size;

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
    this.transferred,
    this.size,
  });

  /// Converts a json object/map to the model.
  factory AuditEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$AuditEntryToJson(this);

  /// Returns a copy with the [transferred] bytes and the [size] of a running
  /// transfer.
  AuditEntry withProgress(int transferred, int size) => AuditEntry.fromJson({
    ...toJson(),
    'transferred': transferred,
    'size': size,
  });

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
      case AuditAction.recordRevoked:
        return locales.auditRecordRevoked;
      case AuditAction.addressChanged:
        return locales.auditAddressChanged;
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
