import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/plant_instance.dart';

import '../plant.dart';

part 'inventory_entry.g.dart';

@HiveType(typeId: 2)
class InventoryEntry extends HiveObject{
  @HiveField(0)
  final String plantDataName;

  @HiveField(1)
  int quantity;

  InventoryEntry({required this.plantDataName, required this.quantity});
}