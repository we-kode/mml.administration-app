import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/share_rule.dart';
import 'package:mml_admin/models/share_settings.dart';

void main() {
  group('ShareRule', () {
    test('parses the criteria and builds the request from their ids', () {
      var rule = ShareRule.fromJson({
        'id': 'r1',
        'groups': [
          {'id': 'gr1', 'name': 'Choir'},
        ],
        'genres': [
          {'genreId': 'g1', 'name': 'Gospel'},
        ],
        'albums': [
          {'albumId': 'a1', 'albumName': 'Album'},
        ],
        'artists': [],
      });

      expect(rule.hasCriteria, isTrue);
      expect(rule.getDisplayDescription(), 'Gospel · Album');
      expect(rule.getTags(), hasLength(1));
      expect(rule.toRequest(), {
        'id': 'r1',
        'groups': ['gr1'],
        'allRecords': false,
        'genres': ['g1'],
        'albums': ['a1'],
        'artists': [],
      });
    });

    test('rule without criteria is detected', () {
      expect(ShareRule().hasCriteria, isFalse);
    });

    test('rule for all records needs no criteria', () {
      var rule = ShareRule.fromJson({
        'groups': [],
        'allRecords': true,
        'genres': [],
        'albums': [],
        'artists': [],
      });

      expect(rule.allRecords, isTrue);
      expect(rule.hasCriteria, isTrue);
      expect(rule.toRequest()['allRecords'], isTrue);
      expect(
        ShareRule.fromJson({
          'genres': [],
          'albums': [],
          'artists': [],
        }).allRecords,
        isFalse,
      );
    });
  });

  group('ShareSettings', () {
    test('defaults to single use links of the longest validity', () {
      var settings = ShareSettings.fromJson({});

      expect(settings.userSettingsAllowed, isFalse);
      expect(settings.userOptions.singleUse, isTrue);
      expect(settings.userOptions.validForHours, 2160);
      expect(settings.searchLinkRetentionDays, 30);
    });

    test('round trips through json', () {
      var settings = ShareSettings.fromJson({
        'userSettingsAllowed': true,
        'userValidForHours': 24,
        'userSingleUse': false,
        'searchLinkRetentionDays': 7,
      });

      expect(settings.toJson(), {
        'userSettingsAllowed': true,
        'userValidForHours': 24,
        'userSingleUse': false,
        'searchLinkRetentionDays': 7,
      });
    });
  });
}
