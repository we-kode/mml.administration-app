import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/views/records/record_tag_filter.dart';

void main() {
  final locales = lookupAppLocalizations(const Locale('en'));

  Future<void> pump(WidgetTester tester, RecordTagFilter filter) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: filter),
      ),
    );
  }

  testWidgets('shows the synchronization filter', (tester) async {
    await pump(tester, RecordTagFilter());

    expect(tester.takeException(), isNull);
    expect(find.text(locales.syncState), findsOneWidget);
  });

  testWidgets('hides the synchronization filters without support', (
    tester,
  ) async {
    await pump(tester, RecordTagFilter(isSyncSupported: false));

    expect(tester.takeException(), isNull);
    expect(find.text(locales.groups), findsOneWidget);
    expect(find.text(locales.unassigned), findsNothing);
    expect(find.text(locales.recordsOfInstance), findsNothing);
    expect(find.text(locales.syncState), findsNothing);
  });
}
