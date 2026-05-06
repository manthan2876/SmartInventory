import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/product_provider.dart';
import '../providers/stock_log_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final lowStockProducts = ref.watch(lowStockProvider);
    final stockLogs = ref.watch(stockLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Products Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Text('${products.length}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.inventory_2, size: 48, color: Colors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Alerts Section
            const Text('Stock Alerts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            if (lowStockProducts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('All stock levels are normal.', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              )
            else
              ...lowStockProducts.map((p) {
                final isCritical = p.quantity == 0;
                final color = isCritical ? Colors.red : Colors.orange;
                final icon = isCritical ? Icons.error_outline : Icons.warning_amber_rounded;
                return _buildAlertCard(
                  context, 
                  p.name, 
                  '${p.quantity} available (Min: ${p.threshold})', 
                  color, 
                  icon
                );
              }),
            
            const SizedBox(height: 24),
            const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            if (stockLogs.isEmpty)
              const Center(child: Text('No recent activity.'))
            else
              ...stockLogs.take(5).map((log) {
                final isAddition = log.type == 'IN';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isAddition ? Colors.green : Colors.redAccent, 
                    child: Icon(isAddition ? Icons.add : Icons.remove, color: Colors.white)
                  ),
                  title: Text('${isAddition ? 'Added' : 'Used'} ${log.productName}'),
                  subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(log.timestamp)),
                  trailing: Text(
                    '${isAddition ? '+' : '-'}${log.amount}', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: isAddition ? Colors.green : Colors.redAccent, 
                      fontSize: 16
                    )
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, String title, String subtitle, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
