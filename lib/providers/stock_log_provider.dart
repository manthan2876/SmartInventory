import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/stock_log.dart';
import '../services/sync_service.dart';

class StockLogNotifier extends Notifier<List<StockLog>> {
  late Box _box;
  final SyncService _syncService = SyncService();

  @override
  List<StockLog> build() {
    _box = Hive.box('stock_logs');
    
    // Trigger background fetch from Firestore to populate Hive
    _syncFromFirebase();

    final logs = _box.values.cast<StockLog>().toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  Future<void> _syncFromFirebase() async {
    final remoteLogs = await _syncService.fetchStockLogs();
    if (remoteLogs.isNotEmpty) {
      for (var log in remoteLogs) {
        _box.put(log.id, log);
      }
      final logs = _box.values.cast<StockLog>().toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      state = logs;
    }
  }

  void addLog(StockLog log) {
    // Insert at the beginning so newest logs show up first
    state = [log, ...state];
    _box.put(log.id, log);
    _syncService.syncStockLog(log);
  }
}

final stockLogProvider = NotifierProvider<StockLogNotifier, List<StockLog>>(() {
  return StockLogNotifier();
});
