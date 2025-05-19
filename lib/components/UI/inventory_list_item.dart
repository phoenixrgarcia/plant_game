import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';

import '../plants/plant.dart';
import '../plants/data/inventory_entry.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryEntry entry;
  final void Function(InventoryEntry entry) onPlant;

  const InventoryListItem({required this.entry, required this.onPlant});

  Plant get plantData => PlantData.getById(entry.plantDataName)!;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(plantData.imagePath, width: 40),
      title: Text(plantData.name),
      subtitle: Text('Quantity: ${entry.quantity}'),
      trailing: ElevatedButton(onPressed: () => onPlant(entry), child: const Text('Plant')),
    );
  }
}
