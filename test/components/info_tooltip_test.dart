import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/components/info_tooltip.dart';

void main() {
  testWidgets('shows the message only on demand', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: InfoTooltip(message: 'Details'))),
      ),
    );

    expect(find.text('Details'), findsNothing);

    await tester.tap(find.byType(InfoTooltip));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Details'), findsOneWidget);

    await tester.pump(const Duration(seconds: 11));
  });
}
