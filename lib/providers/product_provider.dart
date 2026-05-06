import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class ProductNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    return [];
  }

  void addProduct(Product product) {
    state = [...state, product];
  }

  void updateProduct(Product updatedProduct) {
    state = [
      for (final product in state)
        if (product.id == updatedProduct.id) updatedProduct else product
    ];
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  bool updateStock(String id, int amount, String type) {
    bool success = false;
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
            return success ? product.copyWith(quantity: newQuantity) : product;
          }()
        else
          product
    ];
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
