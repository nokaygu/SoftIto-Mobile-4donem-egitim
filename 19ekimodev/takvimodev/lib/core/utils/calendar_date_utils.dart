/// Harici paket (`intl` vb.) kullanmadan saf Dart `DateTime` ile çalışan
/// Türkçe tarih ve takvim ızgarası (Grid) hesaplama yardımcıları.
abstract final class CalendarDateUtils {
  /// Türkçe ay isimleri (1-12).
  static const List<String> monthNames = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  /// Haftanın kısa gün isimleri (Pazartesi = ilk sıra).
  static const List<String> shortWeekdayNames = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  /// Haftanın tam gün isimleri (Pazartesi = ilk sıra).
  static const List<String> fullWeekdayNames = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  /// Verilen yıl ve ayın kaç gün çektiğini hesaplar.
  /// Dart `DateTime(year, month + 1, 0).day` ayın son gününü verir.
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Ayın 1. gününün haftanın hangi gününe denk geldiğini döner (Pazartesi = 1, Pazar = 7).
  static int getFirstWeekdayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }

  /// Takvim ızgarasında (Grid) ayın 1. gününden önce kaç boş kutu bırakılması gerektiğini hesaplar.
  /// Pazartesi = 1 baz alındığında: Pazartesi -> 0 boşluk, Pazar -> 6 boşluk.
  static int getLeadingEmptyCells(int year, int month) {
    return getFirstWeekdayOfMonth(year, month) - 1;
  }

  /// İki `DateTime` nesnesinin aynı takvim günü olup olmadığını kontrol eder.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// İki `DateTime` nesnesinin aynı yıl ve ay içinde olup olmadığını kontrol eder.
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  /// Sadece yıl, ay ve gün bilgisini içeren normalize edilmiş `DateTime` döner.
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Ay ve yıl başlığı üretir (Örn: "Ekim 2026").
  static String formatMonthYear(DateTime date) {
    final monthName = monthNames[date.month - 1];
    return '$monthName ${date.year}';
  }

  /// Tam tarih metni üretir (Örn: "19 Ekim 2026, Pazartesi").
  static String formatFullDate(DateTime date) {
    final monthName = monthNames[date.month - 1];
    final weekdayName = fullWeekdayNames[date.weekday - 1];
    return '${date.day} $monthName ${date.year}, $weekdayName';
  }

  /// Sözlük (Map) anahtarı olarak kullanılacak benzersiz gün dizgesi üretir (`YYYY-MM-DD`).
  static String toDateKey(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
