import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/services/user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('concurrent token refreshes share one request', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final service = UserService.getInstance();

    final first = service.refreshToken();
    final second = service.refreshToken();
    expect(identical(first, second), isTrue);

    await first.catchError((_) {});
    expect(
      identical(service.refreshToken()..catchError((_) {}), first),
      isFalse,
    );
  });
}
