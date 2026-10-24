import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/views/records/record_tag_filter.dart';

void main() {
  testWidgets('shows the synchronization filter', (tester) async {
    final locales = lookupAppLocalizations(const Locale('en'));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: RecordTagFilter()),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text(locales.syncState), findsOneWidget);
  });
}
