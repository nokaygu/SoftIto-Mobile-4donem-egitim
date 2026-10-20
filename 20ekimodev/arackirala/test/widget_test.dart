import 'package:flutter_test/flutter_test.dart';
import 'package:arackirala/main.dart';

void main() {
  testWidgets('VitesApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VitesApp());
    expect(find.byType(VitesApp), findsOneWidget);
  });
}
