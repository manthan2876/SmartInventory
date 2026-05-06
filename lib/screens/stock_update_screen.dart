import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/stock_log.dart';
import '../providers/product_provider.dart';
import '../providers/stock_log_provider.dart';

class StockUpdateScreen extends ConsumerWidget {
  const StockUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Stock', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products available. Add a product first.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isCritical = product.quantity == 0;
                final isLow = product.quantity <= product.threshold && !isCritical;
                
                Color statusColor = Colors.green;
                if (isCritical) statusColor = Colors.red;
                else if (isLow) statusColor = Colors.orange;

                return _buildStockItem(context, ref, product, statusColor);
              },
            ),
    );
  }

  Widget _buildStockItem(BuildContext context, WidgetRef ref, Product product, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 40,
              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${product.quantity} available', style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _updateStock(context, ref, product, 'OUT', 1),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.red,
                  tooltip: 'Stock Out',
                ),
                IconButton(
                  onPressed: () => _updateStock(context, ref, product, 'IN', 1),
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.green,
                  tooltip: 'Stock In',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _updateStock(BuildContext context, WidgetRef ref, Product product, String type, int amount) {
    final success = ref.read(productProvider.notifier).updateStock(product.id, amount, type);
    
    if (success) {
      final log = StockLog(
        id: const Uuid().v4(),
        productId: product.id,
        productName: product.name,
        type: type,
        amount: amount,
        timestamp: DateTime.now(),
      );
      ref.read(stockLogProvider.notifier).addLog(log);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock ${type == 'IN' ? 'Added' : 'Removed'} successfully!'), 
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Insufficient stock!'), 
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
