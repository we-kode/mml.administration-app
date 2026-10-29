/// Columns the audit log can be sorted by.
abstract class AuditSortField {
  /// The creation date.
  static const String timestamp = 'timestamp';

  /// The result of the action.
  static const String status = 'status';

  /// The direction seen from this instance.
  static const String direction = 'direction';

  /// The performed action.
  static const String action = 'action';

  /// The partner instance.
  static const String instance = 'instance';
}
