import 'package:material_ui/material_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/views/announcements/edit.dart';

void main() {
  testWidgets('opens the dialog for a new announcement', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    final locales = lookupAppLocalizations(const Locale('en'));
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: AnnouncementEditDialog(id: null)),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text(locales.createAnnouncement), findsOneWidget);
    expect(find.text(locales.noDevicesSelected), findsOneWidget);

    // Lets the request of the groups time out.
    await tester.pump(const Duration(minutes: 1));
  });
}
