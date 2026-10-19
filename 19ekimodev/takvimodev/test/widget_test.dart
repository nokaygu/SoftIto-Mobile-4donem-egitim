import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takvimodev/core/theme/theme_controller.dart';
import 'package:takvimodev/core/utils/calendar_date_utils.dart';
import 'package:takvimodev/features/calendar/controllers/calendar_controller.dart';
import 'package:takvimodev/features/diary/controllers/diary_controller.dart';
import 'package:takvimodev/main.dart';

void main() {
  group('CalendarDateUtils Birim Testleri', () {
    test('Ay gün sayısı ve Pazartesi bazlı boş kutu hesabı doğrudur', () {
      // Ekim 2026: 31 gün çeker, 1 Ekim 2026 Perşembe (weekday = 4 -> 3 boş kutu)
      expect(CalendarDateUtils.getDaysInMonth(2026, 10), 31);
      expect(CalendarDateUtils.getFirstWeekdayOfMonth(2026, 10), 4);
      expect(CalendarDateUtils.getLeadingEmptyCells(2026, 10), 3);

      // Şubat 2024 (Artık yıl): 29 gün
      expect(CalendarDateUtils.getDaysInMonth(2024, 2), 29);
    });

    test('Türkçe tarih biçimlendirme ve isSameDay doğru çalışır', () {
      final date1 = DateTime(2026, 10, 19, 10, 30);
      final date2 = DateTime(2026, 10, 19, 22, 15);
      final date3 = DateTime(2026, 10, 20);

      expect(CalendarDateUtils.isSameDay(date1, date2), isTrue);
      expect(CalendarDateUtils.isSameDay(date1, date3), isFalse);
      expect(CalendarDateUtils.formatMonthYear(date1), 'Ekim 2026');
      expect(
        CalendarDateUtils.formatFullDate(date1),
        '19 Ekim 2026, Pazartesi',
      );
    });
  });

  group('Günce Widget ve Günlük Akışı Testi', () {
    testWidgets('Gün seçimi, günlük yazma ve takvimde emoji rozeti görünümü', (
      WidgetTester tester,
    ) async {
      final fixedDate = DateTime(2026, 10, 19);
      final themeController = ThemeController();
      final calendarController = CalendarController(initialDate: fixedDate);
      final diaryController = DiaryController();

      await tester.pumpWidget(
        GunceApp(
          themeController: themeController,
          calendarController: calendarController,
          diaryController: diaryController,
        ),
      );

      expect(find.text('Günce'), findsOneWidget);
      expect(find.text('Ekim 2026'), findsOneWidget);
      expect(find.text('19 Ekim 2026, Pazartesi'), findsOneWidget);
      expect(
        find.text('Bu güne ait bir anı henüz yazılmamış ✨'),
        findsOneWidget,
      );

      // "Günlük Yaz" butonunu görünür alana kaydır ve tıkla
      final writeButton = find.text('Günlük Yaz');
      await tester.ensureVisible(writeButton);
      await tester.pumpAndSettle();
      await tester.tap(writeButton);
      await tester.pumpAndSettle();

      // Başlık ve içerik gir, ruh hali seç ve kaydet
      await tester.tap(find.text('Harika'));
      await tester.pump();
      await tester.enterText(
        find.widgetWithText(TextField, 'Günün Başlığı...'),
        'İlk Günce Kaydım',
      );
      await tester.enterText(
        find.widgetWithText(
          TextField,
          'Sevgili güncem, bugün neler hissettin ve yaşadın?...',
        ),
        'Bugün harika bir sonbahar günüydü.',
      );

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      // Kaydedilen anı kartı ve takvimdeki 🤩 rozeti görünmeli
      expect(find.text('İlk Günce Kaydım'), findsOneWidget);
      expect(find.text('Bugün harika bir sonbahar günüydü.'), findsOneWidget);
      expect(find.text('🤩'), findsAtLeastNWidgets(2));
    });
  });
}
