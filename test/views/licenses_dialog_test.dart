import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/oss_licenses.dart';
import 'package:mml_admin/views/settings/license.dart';
import 'package:mml_admin/views/settings/licenses.dart';

void main() {
  testWidgets('lists the packages and opens a license', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: LicensesDialog()),
      ),
    );

    final first = allDependencies.first;
    expect(find.text(first.name), findsOneWidget);

    await tester.tap(find.text(first.name));
    await tester.pumpAndSettle();

    expect(find.byType(LicenseDialog), findsOneWidget);
    expect(find.text(first.license ?? ''), findsOneWidget);
  });
}
