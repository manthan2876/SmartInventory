import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Text('124', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.inventory_2, size: 48, color: Colors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Alerts Section
            const Text('Stock Alerts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Normal Stock Mock
            _buildAlertCard(context, 'Paracetamol 500mg', '150 available', Colors.green, Icons.check_circle),
            
            // Low Stock Mock
            _buildAlertCard(context, 'Surgical Masks', '12 available (Min: 50)', Colors.orange, Icons.warning_amber_rounded),
            
            // Critical Stock Mock
            _buildAlertCard(context, 'Hand Sanitizer 500ml', '2 available (Min: 20)', Colors.red, Icons.error_outline),
            
            const SizedBox(height: 24),
            const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.add, color: Colors.white)),
              title: const Text('Added Paracetamol 500mg'),
              subtitle: const Text('Today, 10:30 AM'),
              trailing: const Text('+50', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.remove, color: Colors.white)),
              title: const Text('Used Surgical Masks'),
              subtitle: const Text('Today, 09:15 AM'),
              trailing: const Text('-10', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16)),
            ),
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
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
