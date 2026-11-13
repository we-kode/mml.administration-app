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

  group('servers without synchronization', () {
    final json = {
      'recordId': 'r1',
      'title': 'Title',
      'duration': 1000,
      'cover': 'aGVsbG8=',
      'locked': false,
      'groups': [],
    };

    test('loads records without an owner instance', () {
      final record = Record.fromJson(json);

      expect(record.ownerInstance, isNull);
      expect(record.isLegacy, isTrue);
      expect(record.toJson().containsKey('ownerInstance'), isFalse);
    });

    test('sends the base64 cover back on updates, so it is kept', () {
      expect(Record.fromJson(json).toJson()['cover'], 'aGVsbG8=');
    });
  });
}
