import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/record.dart';

class _FakeContext extends Fake implements BuildContext {}

void main() {
  final date = DateTime.utc(2026, 11, 4, 23, 30);

  Record record({String? album, String? albumId, DateTime? recordDate}) {
    return Record.fromJson({
      'recordId': 'r1',
      'title': 'Title',
      'duration': 1000,
      'groups': [],
      'date': ?recordDate?.toIso8601String(),
      'album': ?album,
      'albumId': ?albumId,
    });
  }

  test('group contains no album text without an album', () {
    final group = record(recordDate: date).getGroup(_FakeContext())!;

    expect(group, isNot(contains('null')));
    expect(group, isNot(contains(':')));
  });

  test('group filter contains the day and the album', () {
    final filter =
        record(album: 'Album', albumId: 'a1', recordDate: date).getGroupFilter()
            as ID3TagFilter;

    expect(filter.albums, ['a1']);
    expect(filter.startDate, DateTime.utc(2026, 11, 4));
    expect(filter.endDate, DateTime.utc(2026, 11, 4));
  });

  test('group filter contains only the day without an album', () {
    final filter = record(recordDate: date).getGroupFilter() as ID3TagFilter;

    expect(filter.albums, isEmpty);
  });

  test('group filter does not exist, if the server sends no album id', () {
    expect(record(album: 'Album', recordDate: date).getGroupFilter(), isNull);
  });

  test('does not send the album id back', () {
    final json = record(album: 'A', albumId: 'a1', recordDate: date).toJson();

    expect(json.containsKey('albumId'), isFalse);
  });

  test('replacing resets all former filter values and notifies once', () {
    final filter = ID3TagFilter(
      artists: ['artist'],
      groups: ['group'],
      instances: ['instance'],
    )..unassigned = true;
    var notified = 0;
    filter.addListener(() => notified++);

    filter.replaceWith(ID3TagFilter(albums: ['a1']));

    expect(notified, 1);
    expect(filter.albums, ['a1']);
    expect(filter.artists, isEmpty);
    expect(filter.groups, isEmpty);
    expect(filter.instances, isEmpty);
    expect(filter.unassigned, isFalse);
  });
}
