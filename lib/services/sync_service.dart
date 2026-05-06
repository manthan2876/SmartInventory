import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/stock_log.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sync a single product
  Future<void> syncProduct(Product product) async {
    try {
      await _firestore.collection('products').doc(product.id).set({
        'id': product.id,
        'name': product.name,
        'category': product.category,
        'quantity': product.quantity,
        'threshold': product.threshold,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error syncing product to Firebase: $e');
      // In a robust app, we would queue this for retry when online
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product from Firebase: $e');
    }
  }

  // Sync a single stock log
  Future<void> syncStockLog(StockLog log) async {
    try {
      await _firestore.collection('stock_logs').doc(log.id).set({
        'id': log.id,
        'productId': log.productId,
        'productName': log.productName,
        'type': log.type,
        'amount': log.amount,
        'timestamp': log.timestamp.millisecondsSinceEpoch,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error syncing stock log to Firebase: $e');
    }
  }
}
