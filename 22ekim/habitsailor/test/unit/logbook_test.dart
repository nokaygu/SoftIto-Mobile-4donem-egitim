import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailor/core/storage/hive_log_storage.dart';
import 'package:habitsailor/features/controllers/logbook_controller.dart';
import 'package:habitsailor/features/models/captain_log_model.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Box<dynamic> box;
  late HiveLogStorage storage;
  late LogbookController controller;
  const testUser = 'kaptan_ahmet';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_logbook_unit_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>('test_logs_box_${DateTime.now().microsecondsSinceEpoch}');
    storage = HiveLogStorage(boxInstance: box);
    controller = LogbookController(storage: storage);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group("Captain's Logbook (Kaptanın Seyir Defteri) Tests", () {
    test('serializes and deserializes CaptainLogModel properly', () {
      const log = CaptainLogModel(
        id: 'log_01',
        userId: 'kaptan_ali',
        dateIso: '2026-10-23',
        timeString: '14:30',
        title: 'Fırtına Öncesi Sessizlik',
        content: 'Pruva yelkenini çektik, rota açık.',
        weather: '⚡ Fırtına',
        createdAtIso: '2026-10-23T14:30:00.000',
      );

      final map = log.toMap();
      expect(map['id'], equals('log_01'));
      expect(map['weather'], equals('⚡ Fırtına'));

      final restored = CaptainLogModel.fromMap(map);
      expect(restored.id, equals(log.id));
      expect(restored.title, equals(log.title));
      expect(restored.content, equals(log.content));
      expect(restored.weather, equals(log.weather));
    });

    test('seeds welcome log on first user load and allows adding new logs', () async {
      await controller.loadLogsForUser(testUser);

      // Verify welcome log seeded
      expect(controller.logs.isNotEmpty, isTrue);
      expect(controller.logs.first.title, contains('İlk Seyir Kaydı'));

      // Add a custom log
      await controller.addOrUpdateLog(
        dateIso: '2026-10-23',
        timeString: '15:45',
        title: 'Öğleden Sonra Seyri',
        content: 'Zinciri kırmadan 3 görevi de tamamladım.',
        weather: '⛵ Pupayelken',
      );

      final logsToday = controller.getLogsForDate('2026-10-23');
      expect(logsToday.any((l) => l.title == 'Öğleden Sonra Seyri'), isTrue);
    });

    test('deletes a log entry successfully', () async {
      await controller.loadLogsForUser(testUser);

      await controller.addOrUpdateLog(
        id: 'log_to_delete',
        dateIso: '2026-10-23',
        timeString: '16:00',
        title: 'Geçici Not',
        content: 'Silinecek not.',
      );

      expect(controller.logs.any((l) => l.id == 'log_to_delete'), isTrue);

      await controller.deleteLog('log_to_delete');
      expect(controller.logs.any((l) => l.id == 'log_to_delete'), isFalse);
    });
  });
}
