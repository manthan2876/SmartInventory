import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';
import '../services/sync_service.dart';

class ProductNotifier extends Notifier<List<Product>> {
  late Box _box;
  final SyncService _syncService = SyncService();

  @override
  List<Product> build() {
    _box = Hive.box('products');
    
    // Trigger background fetch from Firestore to populate Hive
    _syncFromFirebase();
    
    return _box.values.cast<Product>().toList();
  }

  Future<void> _syncFromFirebase() async {
    final remoteProducts = await _syncService.fetchProducts();
    if (remoteProducts.isNotEmpty) {
      for (var p in remoteProducts) {
        _box.put(p.id, p);
      }
      state = _box.values.cast<Product>().toList();
    }
  }

  void addProduct(Product product) {
    state = [...state, product];
    _box.put(product.id, product);
    _syncService.syncProduct(product);
  }

  void updateProduct(Product updatedProduct) {
    state = [
      for (final product in state)
        if (product.id == updatedProduct.id) updatedProduct else product
    ];
    _box.put(updatedProduct.id, updatedProduct);
    _syncService.syncProduct(updatedProduct);
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
    _box.delete(id);
    _syncService.deleteProduct(id);
  }

  bool updateStock(String id, int amount, String type) {
    bool success = false;
    Product? targetProduct;
    state = [
      for (final product in state)
        if (product.id == id)
          () {
            int newQuantity = product.quantity;
            if (type == 'IN') {
              newQuantity += amount;
              success = true;
            } else if (type == 'OUT') {
              if (newQuantity >= amount) {
                newQuantity -= amount;
                success = true;
              } else {
                success = false; // Cannot have negative stock
              }
            }
            final updated = success ? product.copyWith(quantity: newQuantity) : product;
            if (success) targetProduct = updated;
            return updated;
          }()
        else
          product
    ];
    
    if (success && targetProduct != null) {
      _box.put(targetProduct!.id, targetProduct!);
      _syncService.syncProduct(targetProduct!);
    }
    
    return success;
  }
}

final productProvider = NotifierProvider<ProductNotifier, List<Product>>(() {
  return ProductNotifier();
});

// Computed state for low stock alerts
final lowStockProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productProvider);
  return products.where((p) => p.quantity <= p.threshold).toList();
});
