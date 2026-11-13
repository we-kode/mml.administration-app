/// Registration states of a partner instance.
abstract class PeerState {
  /// This instance requested the registration and waits for the approval of the partner.
  static const int requested = 1;

  /// The partner requested the registration and waits for the approval of the admin.
  static const int pendingApproval = 2;

  /// The admin approved the registration and the partner is not informed yet.
  static const int responsePending = 3;

  /// Records are synchronized with the partner.
  static const int linked = 4;

  /// The registration was rejected.
  static const int rejected = 5;
}
