import 'package:hive/hive.dart';
import 'product.dart';
import 'stock_log.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      quantity: fields[3] as int,
      threshold: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.threshold);
  }
}

class StockLogAdapter extends TypeAdapter<StockLog> {
  @override
  final int typeId = 1;

  @override
  StockLog read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };
    return StockLog(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      type: fields[3] as String,
      amount: fields[4] as int,
      timestamp: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
    );
  }

  @override
  void write(BinaryWriter writer, StockLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.timestamp.millisecondsSinceEpoch);
  }
}
