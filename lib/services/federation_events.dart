import 'dart:async';

import 'package:mml_admin/models/federation/audit_entry.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:signalr_pure/signalr_pure.dart' hide Stream;

/// Types of federation events sent by the server.
enum FederationEventType {
  /// A partner requested a registration.
  requestReceived,

  /// A partner was changed or removed.
  stateChanged,

  /// A new audit log entry was written.
  auditAdded,
}

/// A federation event sent by the server.
class FederationEvent {
  /// The type of the event.
  final FederationEventType type;

  /// The changed partner for [FederationEventType.requestReceived] and
  /// [FederationEventType.stateChanged] events.
  final Peer? peer;

  /// The new entry for [FederationEventType.auditAdded] events.
  final AuditEntry? entry;

  /// Initializes the event.
  const FederationEvent(this.type, {this.peer, this.entry});
}

/// Service receiving the federation events of the server over a socket
/// connection while an admin is logged in.
class FederationEventService {
  /// Instance of the federation event service.
  static final FederationEventService _instance = FederationEventService._();

  /// Delay before the connection is established again after it was lost.
  static const Duration _reconnectDelay = Duration(seconds: 30);

  /// Instance of the [SecureStorageService] to handle data in the secure
  /// storage.
  final SecureStorageService _secureStore = SecureStorageService.getInstance();

  /// Controller of the [events] stream.
  final StreamController<FederationEvent> _events =
      StreamController<FederationEvent>.broadcast();

  HubConnection? _connection;

  Timer? _reconnectTimer;

  bool _isActive = false;

  /// Private constructor of the service.
  FederationEventService._();

  /// Returns the singleton instance of the [FederationEventService].
  static FederationEventService getInstance() {
    return _instance;
  }

  /// Stream of the received federation events.
  Stream<FederationEvent> get events => _events.stream;

  /// Connects to the server socket. Lost connections are established again
  /// until [close] is called.
  Future<void> connect() async {
    _isActive = true;
    _reconnectTimer?.cancel();

    final serverName = await _secureStore.get(
      SecureStorageService.serverNameStorageKey,
    );
    final appKey = await _secureStore.get(
      SecureStorageService.appKeyStorageKey,
    );
    final accessToken = await _secureStore.get(
      SecureStorageService.accessTokenStorageKey,
    );

    final builder = HubConnectionBuilder()
      ..url = 'https://$serverName/hub/federation'
      ..httpConnectionOptions = HttpConnectionOptions(
        headers: {"App-Key": "$appKey", "Authorization": "Bearer $accessToken"},
      )
      ..logLevel = LogLevel.error
      ..reconnect = true;

    final connection = builder.build();
    connection.on('FEDERATION_REQUEST_RECEIVED', (args) {
      _events.add(
        FederationEvent(FederationEventType.requestReceived, peer: _peer(args)),
      );
    });
    connection.on('FEDERATION_STATE_CHANGED', (args) {
      _events.add(
        FederationEvent(FederationEventType.stateChanged, peer: _peer(args)),
      );
    });
    connection.on('FEDERATION_AUDIT_ADDED', (args) {
      _events.add(
        FederationEvent(
          FederationEventType.auditAdded,
          entry: args.isNotEmpty ? AuditEntry.fromJson(args.first) : null,
        ),
      );
    });
    connection.onclose((_) => _scheduleReconnect());
    _connection = connection;

    try {
      await connection.startAsync();
    } catch (_) {
      _scheduleReconnect();
    }
  }

  /// Stops the socket connection.
  Future<void> close() async {
    _isActive = false;
    _reconnectTimer?.cancel();
    final connection = _connection;
    _connection = null;
    try {
      await connection?.stopAsync();
    } catch (_) {
      // The connection is closed already.
    }
  }

  void _scheduleReconnect() {
    if (!_isActive) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_isActive) {
        connect();
      }
    });
  }

  Peer? _peer(List<dynamic> args) {
    return args.isNotEmpty ? Peer.fromJson(args.first) : null;
  }
}
