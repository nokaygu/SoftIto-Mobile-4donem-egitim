import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadim App exercise add and remove test', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // 1. Egzersiz sekmesine geç
    await tester.tap(find.text('Egzersiz'));
    await tester.pumpAndSettle();

    // 2. Varsayılan egzersizlerin olduğunu doğrula
    expect(find.text('HIIT Kardiyo & Isınma'), findsOneWidget);

    // 3. Bir egzersizi sil (çöp kutusu ikonuna tıkla)
    final deleteButtons = find.byTooltip('Egzersizi Sil');
    expect(deleteButtons, findsWidgets);
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // 4. Silinen egzersizin artık ekranda olmadığını doğrula
    expect(find.text('HIIT Kardiyo & Isınma'), findsNothing);

    // 5. FAB üzerinden yeni egzersiz ekleme modalını aç
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // 6. Modal başlığını doğrula ve 'Egzersizi Ekle' butonuna bas
    expect(find.text('Yeni Egzersiz Kartı Ekle'), findsOneWidget);
    await tester.tap(find.text('Egzersizi Ekle'));
    await tester.pumpAndSettle();

    // 7. Yeni eklenen 'Squat & Bacak' kartını doğrula
    expect(find.text('Squat & Bacak'), findsOneWidget);
  });
}
