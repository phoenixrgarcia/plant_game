import 'package:plant_game/components/plants/plant_instance.dart';

import '../plant.dart';

class InventoryEntry {
  final Plant plant;
  int quantity;

  InventoryEntry({required this.plant, required this.quantity});
}