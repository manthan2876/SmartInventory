class Product {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final int threshold;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.threshold,
  });

  Product copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    int? threshold,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      threshold: threshold ?? this.threshold,
    );
  }
}
