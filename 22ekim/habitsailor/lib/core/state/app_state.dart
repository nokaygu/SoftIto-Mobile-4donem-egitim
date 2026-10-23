import '../storage/hive_auth_storage.dart';
import '../storage/hive_log_storage.dart';
import '../storage/hive_task_storage.dart';
import '../../features/controllers/auth_controller.dart';
import '../../features/controllers/logbook_controller.dart';
import '../../features/controllers/task_controller.dart';

class AppState {
  static final AppState instance = AppState._internal();

  late final HiveAuthStorage authStorage;
  late final HiveTaskStorage taskStorage;
  late final HiveLogStorage logStorage;
  late final AuthController authController;
  late final TaskController taskController;
  late final LogbookController logbookController;

  AppState._internal() {
    authStorage = HiveAuthStorage();
    taskStorage = HiveTaskStorage();
    logStorage = HiveLogStorage();
    authController = AuthController(authStorage: authStorage);
    taskController = TaskController(storage: taskStorage);
    logbookController = LogbookController(storage: logStorage);
  }

  Future<void> init() async {
    await taskStorage.init();
    await logStorage.init();
    await authController.init();

    final user = authController.currentUser;
    if (user != null) {
      await taskController.loadTasksForUser(user.username);
      await logbookController.loadLogsForUser(user.username);
      await authController.syncTotalStreak(taskController.getTotalStreakPoints());
    }

    // Keep tasks & logs in sync when auth state changes (login / register / logout)
    authController.addListener(() async {
      final activeUser = authController.currentUser;
      if (activeUser != null) {
        if (taskController.currentUsername != activeUser.username) {
          await taskController.loadTasksForUser(activeUser.username);
          await authController.syncTotalStreak(taskController.getTotalStreakPoints());
        }
        if (logbookController.currentUsername != activeUser.username) {
          await logbookController.loadLogsForUser(activeUser.username);
        }
      } else {
        taskController.clearTasks();
        logbookController.clearLogs();
      }
    });

    // Keep auth user's streak in sync when tasks change
    taskController.addListener(() {
      final updatedStreak = taskController.getTotalStreakPoints();
      authController.syncTotalStreak(updatedStreak);
    });
  }
}
