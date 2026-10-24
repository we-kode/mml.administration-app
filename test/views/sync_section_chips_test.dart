import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/components/select_chip.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/sync/overview.dart';
import 'package:mml_admin/views/sync/section_chips.dart';

void main() {
  testWidgets('selects exactly one section, invitations first', (tester) async {
    final section = ValueNotifier(SyncSection.invitations);
    final locales = lookupAppLocalizations(const Locale('en'));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: section,
            builder: (context, _, _) => SyncSectionChips(section: section),
          ),
        ),
      ),
    );

    List<SelectChip> chips() =>
        tester.widgetList<SelectChip>(find.byType(SelectChip)).toList();

    expect(chips().map((c) => c.label), [
      locales.invitations,
      locales.peers,
      locales.rules,
      locales.audit,
    ]);
    expect(chips().where((c) => c.selected).map((c) => c.label), [
      locales.invitations,
    ]);

    await tester.tap(find.text(locales.audit));
    await tester.pump();

    expect(section.value, SyncSection.audit);
    expect(chips().where((c) => c.selected).map((c) => c.label), [
      locales.audit,
    ]);
  });
}
