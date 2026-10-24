import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/components/tag_selection.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/model_list.dart';

void main() {
  testWidgets('shows the selected items by name and removes them', (
    tester,
  ) async {
    final values = [
      Artist(artistId: 'a1', name: 'Queen'),
      Artist(artistId: 'a2', name: 'ABBA'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TagSelection<Artist>(
            label: 'Artist',
            values: values,
            loadData: ({filter, offset, take}) async => ModelList([], 0, 0),
          ),
        ),
      ),
    );

    expect(find.text('Queen'), findsOneWidget);
    expect(find.text('ABBA'), findsOneWidget);

    tester.widget<InputChip>(find.byType(InputChip).first).onDeleted!();
    await tester.pump();

    expect(values.map((a) => a.artistId), ['a2']);
    expect(find.text('Queen'), findsNothing);
  });
}
