import '../view_models/sync_audit_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/audit_sort_field.dart';
import 'package:mml_admin/view_models/sync/audit.dart';
import 'package:mml_admin/views/sync/audit.dart';

void main() {
  final locales = lookupAppLocalizations(const Locale('en'));

  Future<AuditViewModel> pumpTable(WidgetTester tester, int count) async {
    final vm = AuditViewModel(
      ValueNotifier(0),
      service: FakeAuditService(count),
    );
    await vm.init();
    await tester.binding.setSurfaceSize(const Size(1600, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: ListenableBuilder(
            listenable: vm,
            builder: (context, _) => AuditTable(vm: vm),
          ),
        ),
      ),
    );
    return vm;
  }

  testWidgets('shows no data for an empty log', (tester) async {
    await pumpTable(tester, 0);

    expect(find.text(locales.noData), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the columns, icons and the page info', (tester) async {
    await pumpTable(tester, 30);

    for (final column in [
      locales.date,
      locales.auditResult,
      locales.auditDirection,
      locales.auditAction,
      locales.instance,
      locales.records,
      locales.auditMessage,
    ]) {
      expect(find.text(column), findsOneWidget);
    }
    expect(find.byTooltip(locales.auditSuccess), findsWidgets);
    expect(find.byTooltip(locales.auditOutgoing), findsWidgets);
    expect(find.text('1–25 of 30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('resizes a column by dragging its border', (tester) async {
    await pumpTable(tester, 3);
    final before = tester.getTopLeft(find.text(locales.auditResult)).dx;
    final handle = find.byWidgetPredicate(
      (w) => w is MouseRegion && w.cursor == SystemMouseCursors.resizeColumn,
    );

    await tester.drag(handle.first, const Offset(100, 0));
    await tester.pump();
    // The drag gesture consumes the touch slop before it starts.
    expect(
      tester.getTopLeft(find.text(locales.auditResult)).dx,
      greaterThan(before + 50),
    );

    await tester.drag(handle.first, const Offset(-1000, 0));
    // Waits for the double tap timeout of the handle, which resets the width.
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('cycles the sort order and shows the priority', (tester) async {
    final vm = await pumpTable(tester, 3);

    await tester.tap(find.text(locales.auditResult));
    await tester.pump();
    expect(find.byIcon(Symbols.arrow_upward), findsOneWidget);

    await tester.tap(find.text(locales.date));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text(locales.auditResult));
    await tester.pump();
    expect(vm.filter.sortOf(AuditSortField.status)?.descending, isTrue);
  });
}
