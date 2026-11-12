import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/views/settings/license.dart';
import 'package:mml_admin/views/settings/licenses.dart';

void main() {
  setUp(() {
    LicenseRegistry.reset();
    LicenseRegistry.addLicense(
      () => Stream.fromIterable([
        const LicenseEntryWithLineBreaks(['zeta'], 'Zeta license'),
        const LicenseEntryWithLineBreaks(['alpha', 'zeta'], 'Shared license'),
      ]),
    );
  });

  tearDown(LicenseRegistry.reset);

  testWidgets('lists registered packages sorted and opens their licenses', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: LicensesDialog()),
      ),
    );
    await tester.pumpAndSettle();

    final names = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.title as Text).data)
        .toList();
    expect(names, ['alpha', 'zeta']);

    await tester.tap(find.text('zeta'));
    await tester.pumpAndSettle();

    expect(find.byType(LicenseDialog), findsOneWidget);
    expect(find.text('Zeta license'), findsOneWidget);
    expect(find.text('Shared license'), findsOneWidget);
  });
}
