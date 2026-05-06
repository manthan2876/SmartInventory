import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/stock_log_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(stockLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No history available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final isAddition = log.type == 'IN';
                
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isAddition ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      child: Icon(
                        isAddition ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isAddition ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      '${isAddition ? 'Stock In' : 'Stock Out'}: ${log.productName}', 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(log.timestamp)),
                    trailing: Text(
                      '${isAddition ? '+' : '-'}${log.amount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isAddition ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
