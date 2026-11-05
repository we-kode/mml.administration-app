import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/list_subfilter_view.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record.dart';

class _TagFilter extends ListSubfilterView {
  const _TagFilter(ID3TagFilter filter) : super(filter: filter);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  late ID3TagFilter tagFilter;
  late List<String?> loads;

  Record record({String? albumId}) => Record.fromJson({
    'recordId': 'r1',
    'title': 'Title',
    'duration': 1000,
    'groups': [],
    'date': '2026-11-04T10:00:00Z',
    'album': 'Album',
    'albumId': ?albumId,
  });

  Future<void> show(WidgetTester tester, Record item) async {
    tester.view.physicalSize = const Size(2560, 1440);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: AsyncListView(
          subfilter: _TagFilter(tagFilter),
          availableTags: ModelList([], 0, 0),
          onChangedAvailableTags: (item, tags) {},
          deleteItems: <T>(List<T> items) async => false,
          editItem: (item, subfilter) async => false,
          loadData: ({String? filter, int? offset, int? take, subfilter}) {
            loads.add(filter);
            return Future.value(ModelList([item], offset ?? 0, 1));
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    tagFilter = ID3TagFilter(artists: ['old']);
    loads = [];
  });

  testWidgets('tap on a group replaces all filters and reloads once', (
    tester,
  ) async {
    await show(tester, record(albumId: 'a1'));
    await tester.enterText(find.byType(TextField), 'text');
    await tester.pumpAndSettle();
    loads.clear();

    final chip = tester.widget<ActionChip>(find.byType(ActionChip));
    expect(chip.mouseCursor, SystemMouseCursors.click);

    await tester.tap(find.byType(ActionChip));
    await tester.pumpAndSettle();

    expect(tagFilter.albums, ['a1']);
    expect(tagFilter.artists, isEmpty);
    expect(find.text('text'), findsNothing);
    expect(loads, [null]);
  });

  testWidgets('groups, which can not be filtered, are not tappable', (
    tester,
  ) async {
    await show(tester, record());

    expect(find.byType(ActionChip), findsNothing);
    expect(find.byType(Chip), findsOneWidget);
  });
}
