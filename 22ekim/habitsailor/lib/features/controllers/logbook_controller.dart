import 'package:flutter/foundation.dart';
import '../../core/storage/hive_log_storage.dart';
import '../models/captain_log_model.dart';

class LogbookController extends ChangeNotifier {
  final HiveLogStorage storage;
  List<CaptainLogModel> _logs = [];
  bool _isLoading = false;
  String? _currentUsername;

  LogbookController({required this.storage});

  List<CaptainLogModel> get logs => List.unmodifiable(_logs);
  bool get isLoading => _isLoading;
  String? get currentUsername => _currentUsername;

  Future<void> loadLogsForUser(String username) async {
    _currentUsername = username;
    await storage.seedDemoLogsIfEmptyForUser(username);
    loadLogs();
  }

  void loadLogs() {
    _isLoading = true;
    notifyListeners();

    try {
      if (_currentUsername != null && _currentUsername!.isNotEmpty) {
        _logs = storage.getLogsForUser(_currentUsername!);
      } else {
        _logs = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CaptainLogModel> getLogsForDate(String dateIso) {
    return _logs.where((l) => l.dateIso == dateIso).toList();
  }

  Future<void> addOrUpdateLog({
    String? id,
    required String dateIso,
    required String timeString,
    required String title,
    required String content,
    String weather = '☀️ Sakin Deniz',
  }) async {
    final username = _currentUsername ?? 'kaptan';
    final logId = id ?? 'log_${DateTime.now().millisecondsSinceEpoch}';

    final entry = CaptainLogModel(
      id: logId,
      userId: username,
      dateIso: dateIso,
      timeString: timeString,
      title: title.trim().isEmpty ? 'Seyir Notu' : title.trim(),
      content: content.trim(),
      weather: weather,
      createdAtIso: DateTime.now().toIso8601String(),
    );

    await storage.saveOrUpdateLog(entry);
    loadLogs();
  }

  Future<void> deleteLog(String logId) async {
    await storage.deleteLog(logId);
    loadLogs();
  }

  void clearLogs() {
    _currentUsername = null;
    _logs = [];
    notifyListeners();
  }
}
