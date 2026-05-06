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
    final logs = _box.values.cast<StockLog>().toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
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
