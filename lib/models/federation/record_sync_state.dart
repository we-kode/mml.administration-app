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

  /// The record is waiting to be sent or is being sent to a partner.
  static const int pending = 4;

  /// All states in the order they are offered in filters.
  static const List<int> all = [received, sent, pending, problem, none];
}
