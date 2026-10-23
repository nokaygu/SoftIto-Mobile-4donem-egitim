import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habitsailor/core/storage/hive_auth_storage.dart';
import 'package:habitsailor/features/controllers/auth_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Box<dynamic> box;
  late HiveAuthStorage storage;
  late AuthController controller;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_auth_unit_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>('test_users_box_${DateTime.now().microsecondsSinceEpoch}');
    storage = HiveAuthStorage(box: box);
    controller = AuthController(authStorage: storage);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Registration & Duplicate Prevention Tests (Pure Hive Engine)', () {
    test('successfully registers a new user with secure password storage', () async {
      final result = await storage.registerUser(
        username: 'KaptanOruç',
        password: 'securePass123',
      );

      expect(result.success, isTrue);
      expect(result.user, isNotNull);
      expect(result.user!.username, equals('KaptanOruç'));

      // Test login with the new user
      final loggedIn = await storage.loginUser(
        username: 'KaptanOruç',
        password: 'securePass123',
      );
      expect(loggedIn, isNotNull);
      expect(loggedIn!.username, equals('KaptanOruç'));
    });

    test('strictly rejects duplicate registration with existing username (case-insensitive)', () async {
      final first = await storage.registerUser(
        username: 'KaptanMurat',
        password: 'pass1234',
      );
      expect(first.success, isTrue);

      // Attempt second registration with exact same name
      final second = await storage.registerUser(
        username: 'KaptanMurat',
        password: 'otherPassword',
      );
      expect(second.success, isFalse);
      expect(second.errorMessage, contains('zaten alınmış'));

      // Attempt third registration with different casing and whitespace
      final third = await storage.registerUser(
        username: '  kaptanmurat  ',
        password: 'anotherPassword',
      );
      expect(third.success, isFalse);
      expect(third.errorMessage, contains('zaten alınmış'));
    });

    test('rejects invalid username or weak password', () async {
      final shortUser = await storage.registerUser(
        username: 'al',
        password: 'validPass',
      );
      expect(shortUser.success, isFalse);
      expect(shortUser.errorMessage, contains('en az 3 karakter'));

      final shortPass = await storage.registerUser(
        username: 'GecerliIsim',
        password: '12',
      );
      expect(shortPass.success, isFalse);
      expect(shortPass.errorMessage, contains('en az 4 karakter'));
    });

    test('login rejects wrong password', () async {
      await storage.registerUser(
        username: 'KaptanPiri',
        password: 'correctPassword',
      );

      final result = await storage.loginUser(
        username: 'KaptanPiri',
        password: 'wrongPassword',
      );
      expect(result, isNull);
    });

    test('updatePassword updates credentials securely and allows login with new password', () async {
      await storage.registerUser(
        username: 'Seyyah',
        password: 'oldPassword1',
      );

      final updateSuccess = await storage.updatePassword(
        username: 'Seyyah',
        newPassword: 'newSuperPassword2',
      );
      expect(updateSuccess, isTrue);

      // Old password should fail
      final oldLogin = await storage.loginUser(
        username: 'Seyyah',
        password: 'oldPassword1',
      );
      expect(oldLogin, isNull);

      // New password should succeed
      final newLogin = await storage.loginUser(
        username: 'Seyyah',
        password: 'newSuperPassword2',
      );
      expect(newLogin, isNotNull);
      expect(newLogin!.username, equals('Seyyah'));
    });

    test('AuthController sailorRank calculates correctly based on streak', () async {
      await controller.register('KaptanTest', 'pass1234');

      expect(controller.sailorRank, equals('Hevesli Tayfa ⛵'));

      await controller.syncTotalStreak(10);
      expect(controller.sailorRank, equals('Usta Dümenci 🧭'));

      await controller.syncTotalStreak(35);
      expect(controller.sailorRank, equals('Açık Deniz Kaptanı ⚓'));
    });
  });
}
