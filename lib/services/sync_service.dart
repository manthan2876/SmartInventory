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

  // Fetch all products from Firebase
  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: data['id'],
          name: data['name'],
          category: data['category'],
          quantity: data['quantity'],
          threshold: data['threshold'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching products from Firebase: $e');
      return [];
    }
  }

  // Fetch all stock logs from Firebase
  Future<List<StockLog>> fetchStockLogs() async {
    try {
      final snapshot = await _firestore.collection('stock_logs').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StockLog(
          id: data['id'],
          productId: data['productId'],
          productName: data['productName'],
          type: data['type'],
          amount: data['amount'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching stock logs from Firebase: $e');
      return [];
    }
  }
}
