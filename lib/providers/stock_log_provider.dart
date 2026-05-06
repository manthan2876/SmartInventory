import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_log.dart';

class StockLogNotifier extends Notifier<List<StockLog>> {
  @override
  List<StockLog> build() {
    return [];
  }

  void addLog(StockLog log) {
    // Insert at the beginning so newest logs show up first
    state = [log, ...state];
  }
}

final stockLogProvider = NotifierProvider<StockLogNotifier, List<StockLog>>(() {
  return StockLogNotifier();
});
