import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/record.dart';

void main() {
  test('does not send the cover file name on updates', () {
    final record = Record.fromJson({
      'recordId': 'r1',
      'title': 'Title',
      'duration': 1000,
      'ownerInstance': 'alpha',
      'cover': 'cover.jpg',
      'groups': [],
    });

    expect(record.cover, 'cover.jpg');
    expect(record.toJson().containsKey('cover'), isFalse);
  });
}
