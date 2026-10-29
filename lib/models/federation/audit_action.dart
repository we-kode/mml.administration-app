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

  /// The synchronization of an own record with a partner was revoked.
  static const int recordRevoked = 12;

  /// The address of an instance changed.
  static const int addressChanged = 13;

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
    recordRevoked,
    addressChanged,
  ];
}
