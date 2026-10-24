import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/sync/invitations.dart';
import 'package:mml_admin/views/sync/invitations.dart';

void main() {
  testWidgets('cancel closes the dialog without an invitation', (tester) async {
    final locales = lookupAppLocalizations(const Locale('en'));
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showDialog<bool>(
              context: context,
              builder: (context) =>
                  InvitationDialog(vm: InvitationsViewModel()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text(locales.invitationNew), findsOneWidget);
    expect(find.text(locales.create), findsOneWidget);
    expect(find.text(locales.durationHours(24)), findsWidgets);

    await tester.tap(find.text(locales.cancel));
    await tester.pumpAndSettle();
    expect(result, isFalse);
    expect(find.text(locales.invitationNew), findsNothing);
  });
}
