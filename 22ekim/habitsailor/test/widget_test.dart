import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailor/main.dart';

void main() {
  testWidgets('HabitSailorApp initial smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitSailorApp());
    expect(find.byType(HabitSailorApp), findsOneWidget);
  });
}
