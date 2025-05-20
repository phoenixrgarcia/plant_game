import 'package:hive_flutter/hive_flutter.dart';

part 'inventory_entry.g.dart';

@HiveType(typeId: 2)
class InventoryEntry extends HiveObject{
  @HiveField(0)
  final String plantDataName;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  int tier;

  InventoryEntry({required this.plantDataName, required this.quantity, required this.tier});
}