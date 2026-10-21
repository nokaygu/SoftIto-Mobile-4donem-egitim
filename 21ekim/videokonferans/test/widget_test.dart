import 'package:flutter_test/flutter_test.dart';
import 'package:videokonferans/main.dart';

void main() {
  testWidgets('VizyonMeet app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VizyonMeetApp());
    expect(find.byType(VizyonMeetApp), findsOneWidget);
  });
}
