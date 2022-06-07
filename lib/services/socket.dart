class SocketService {
  /// Instance of the secure storage service.
  static final SocketService _instance = SocketService._();

  /// Private constructor of the service.
  SocketService._();

  /// Returns the singleton instance of the [SocketService].
  static SocketService getInstance() {
    return _instance;
  }
}