import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/view_models/clients/register.dart';

void main() {
  ClientsRegisterViewModel createViewModel() {
    return ClientsRegisterViewModel()
      ..similarClients = ModelList(
        [
          Client(clientId: 'c1', displayName: 'Phone'),
          Client(clientId: 'c2', displayName: 'Phone'),
        ],
        0,
        2,
      );
  }

  test('stays on the similar clients while some are left', () {
    final vm = createViewModel();

    vm.removeSimilarClient(0);

    expect(vm.similarClients.length, 1);
    expect(vm.state, isNot(RegistrationState.register));
  });

  test('continues with the registration form after the last one', () {
    final vm = createViewModel();

    vm.removeSimilarClient(1);
    vm.removeSimilarClient(0);

    expect(vm.similarClients, isEmpty);
    expect(vm.state, RegistrationState.register);
  });
}
