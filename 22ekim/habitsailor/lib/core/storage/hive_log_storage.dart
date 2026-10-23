import 'package:hive_flutter/hive_flutter.dart';
import '../../features/models/captain_log_model.dart';

class HiveLogStorage {
  static const String boxName = 'habitsailor_logs_box';
  Box<dynamic>? boxInstance;

  HiveLogStorage({this.boxInstance});

  Future<void> init() async {
    await Hive.initFlutter();
    boxInstance = await Hive.openBox<dynamic>(boxName);
  }

  Box<dynamic> get box {
    final b = boxInstance;
    if (b == null || !b.isOpen) {
      throw StateError('HiveLogStorage has not been initialized. Call init() first.');
    }
    return b;
  }

  List<CaptainLogModel> getLogsForUser(String username) {
    final cleanUsername = username.trim().toLowerCase();
    final List<CaptainLogModel> list = [];

    for (final item in box.values) {
      if (item is Map) {
        final log = CaptainLogModel.fromMap(item);
        if (log.userId.trim().toLowerCase() == cleanUsername) {
          list.add(log);
        }
      }
    }

    // Sort newest first
    list.sort((a, b) => b.createdAtIso.compareTo(a.createdAtIso));
    return list;
  }

  List<CaptainLogModel> getLogsForDate(String username, String dateIso) {
    return getLogsForUser(username)
        .where((log) => log.dateIso == dateIso)
        .toList();
  }

  Future<void> saveOrUpdateLog(CaptainLogModel log) async {
    await box.put(log.id, log.toMap());
  }

  Future<void> deleteLog(String logId) async {
    await box.delete(logId);
  }

  Future<void> seedDemoLogsIfEmptyForUser(String username) async {
    final cleanUsername = username.trim();
    if (cleanUsername.isEmpty) return;

    final existing = getLogsForUser(cleanUsername);
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final todayIso = '$year-$month-$day';
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final welcomeLog = CaptainLogModel(
      id: '${cleanUsername}_welcome_log',
      userId: cleanUsername,
      dateIso: todayIso,
      timeString: timeStr,
      title: 'İlk Seyir Kaydı: Pruva Neta! ⛵',
      content: 'Kaptan olarak Habit Sailor güvertesine ilk adımı attım. '
          'Zinciri kırmadan, her gün küçük ama kararlı adımlarla hedeflerime doğru yelken açıyorum. '
          'Rüzgarım kolayına, rotam daima neta olsun!',
      weather: '⛵ Pupayelken',
      createdAtIso: now.toIso8601String(),
    );

    await saveOrUpdateLog(welcomeLog);
  }
}
