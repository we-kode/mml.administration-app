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
