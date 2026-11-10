import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/components/progress_ring.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

void main() {
  testWidgets('shows the progress and the percentage', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: ProgressRing(value: 0.426)),
      ),
    );

    expect(find.text('42 %'), findsOneWidget);
    final ring = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(ring.value, 0.426);
  });
}
