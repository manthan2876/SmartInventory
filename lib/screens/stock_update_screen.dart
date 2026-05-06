import 'package:flutter/material.dart';

class StockUpdateScreen extends StatelessWidget {
  const StockUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Stock', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Select a product to update stock', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          _buildStockItem(context, 'Paracetamol 500mg', '150 available', Colors.green),
          _buildStockItem(context, 'Surgical Masks', '12 available', Colors.orange),
          _buildStockItem(context, 'Hand Sanitizer 500ml', '2 available', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStockItem(BuildContext context, String title, String subtitle, Color statusColor) {
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock Out Recorded')));
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.red,
                  tooltip: 'Stock Out',
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock In Recorded')));
                  },
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
}
