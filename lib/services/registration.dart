import 'package:mml_admin/models/client_registration.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:signalr_pure/signalr_pure.dart';

/// Function called when the actual registration token has been updated.
typedef UpdateTokenFunction = void Function(ClientRegistration tokenInfo);

/// Function called, when a client registered successful.
typedef ClientRegisteredFunction = void Function<String>(String clientId);

/// Service creating a socket connection to the server for getting registration tokens.
class RegistrationService {
  /// Instance of the [SecureStorageService] to handle data in the secure
  /// storage.
  final SecureStorageService _secureStore = SecureStorageService.getInstance();

  /// The SingalR connection.
  late HubConnection _connection;

  /// Function called, when a cleint has been updated.
  final UpdateTokenFunction onUpdate;

  /// Function called, when a client registered successful.
  final ClientRegisteredFunction onRegistered;

  /// Initialize the [RegistrationService]].
  RegistrationService({
    required this.onUpdate,
    required this.onRegistered,
  });

  /// Connects to the server socket.
  Future<void> connect() async {
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
      ..url = 'https://$serverName/hub/client'
      ..httpConnectionOptions = HttpConnectionOptions(
        headers: {
          "App-Key": "$appKey",
          "Authorization": "Bearer $accessToken",
        },
      )
      ..logLevel = LogLevel.error
      ..reconnect = true;

    _connection = builder.build();
    _connection.on(
      'REGISTER_TOKEN_UPDATED',
      (args) {
        if (args.isNotEmpty) {
          var tokenInfo = ClientRegistration.fromJson(args.first);
          tokenInfo.endpoint = serverName;
          onUpdate(tokenInfo);
        }
      },
    );
    _connection.on(
      'CLIENT_REGISTERED',
      <String>(String clientId) => onRegistered(clientId),
    );

    await _connection.startAsync();
    await _connection.sendAsync('SubscribeToClientRegistration', []);
  }

  /// Stops the scoket connection.
  Future<void> close() async {
    await _connection.stopAsync();
  }
}
