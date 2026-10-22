import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailer/main.dart';

void main() {
  testWidgets('HabitSailerApp initial smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitSailerApp());
    expect(find.byType(HabitSailerApp), findsOneWidget);
  });
}
