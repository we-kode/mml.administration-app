import 'package:mml_admin/models/federation/audit_entry.dart';

/// One page of audit log entries.
class AuditEntries {
  /// The loaded entries.
  final List<AuditEntry> items;

  /// The count of all entries matching the filter.
  final int totalCount;

  /// Initializes the page.
  AuditEntries(this.items, this.totalCount);
}
