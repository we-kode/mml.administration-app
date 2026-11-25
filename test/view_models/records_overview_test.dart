import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/view_models/records/overview.dart';

void main() {
  test('ignores a second picker while one is open', () async {
    final picker = Completer<String?>();
    var opened = 0;

    final first = RecordsViewModel.pick(() {
      opened++;
      return picker.future;
    });
    final second = await RecordsViewModel.pick(() async {
      opened++;
      return 'second';
    });

    expect(second, isNull);
    picker.complete('folder');
    expect(await first, 'folder');
    expect(opened, 1);
  });

  test('allows a new picker after the previous one failed', () async {
    await expectLater(
      RecordsViewModel.pick<String>(() async => throw Exception('failed')),
      throwsException,
    );

    expect(await RecordsViewModel.pick(() async => 'folder'), 'folder');
  });
}
