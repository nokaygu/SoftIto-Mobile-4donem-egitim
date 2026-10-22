import '../storage/hive_task_storage.dart';
import '../storage/secure_auth_storage.dart';
import '../../features/controllers/auth_controller.dart';
import '../../features/controllers/task_controller.dart';

class AppState {
  static final AppState instance = AppState._internal();

  late final SecureAuthStorage authStorage;
  late final HiveTaskStorage taskStorage;
  late final AuthController authController;
  late final TaskController taskController;

  AppState._internal() {
    authStorage = SecureAuthStorage();
    taskStorage = HiveTaskStorage();
    authController = AuthController(secureStorage: authStorage);
    taskController = TaskController(storage: taskStorage);
  }

  Future<void> init() async {
    await taskStorage.init();
    taskController.loadTasks();
    await authController.init();

    // Sync streak points
    final totalStreak = taskController.getTotalStreakPoints();
    await authController.syncTotalStreak(totalStreak);

    // Keep auth user's streak in sync when tasks change
    taskController.addListener(() {
      final updatedStreak = taskController.getTotalStreakPoints();
      authController.syncTotalStreak(updatedStreak);
    });
  }
}
