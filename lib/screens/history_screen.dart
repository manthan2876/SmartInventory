import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          final isAddition = index % 2 == 0;
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
              title: Text(isAddition ? 'Stock In: Product $index' : 'Stock Out: Product $index', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
              trailing: Text(
                isAddition ? '+50' : '-10',
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
