class StockLog {
  final String id;
  final String productId;
  final String productName; // Denormalized for easier display in UI
  final String type; // 'IN' or 'OUT'
  final int amount;
  final DateTime timestamp;

  StockLog({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.amount,
    required this.timestamp,
  });
}
