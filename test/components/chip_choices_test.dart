import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';

void main() {
  final groups = ModelList(
    [Group(id: 'g1', name: 'Family'), Group(id: 'g2', name: 'Kids')],
    0,
    2,
  );

  Future<void> pumpChips(WidgetTester tester, List<ModelBase> selected) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChipChoices(
            selectableItems: groups,
            initialSelectedItems: selected,
            onSelectionChanged: (_) {},
          ),
        ),
      ),
    );
  }

  bool isSelected(WidgetTester tester, String label) => tester
      .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, label))
      .selected;

  testWidgets('shows a changed selection when the widget is rebuilt', (
    tester,
  ) async {
    await pumpChips(tester, []);
    expect(isSelected(tester, 'Family'), isFalse);

    await pumpChips(tester, [Group(id: 'g1', name: 'Family')]);

    expect(isSelected(tester, 'Family'), isTrue);
    expect(isSelected(tester, 'Kids'), isFalse);
  });

  testWidgets('keeps the user selection when rebuilt with the same list', (
    tester,
  ) async {
    final selected = <ModelBase>[];
    await pumpChips(tester, selected);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Kids'));
    await pumpChips(tester, selected);

    expect(isSelected(tester, 'Kids'), isTrue);
  });
}
