import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/plant_instance.dart';

import '../plants/data/inventory_entry.dart';
import '../../game_state_provider.dart';

class InventoryListItem extends ConsumerWidget {
  final InventoryEntry entry;
  final bool canPlant;
  final int? potCol;
  final int? potRow;

  const InventoryListItem({
    super.key,
    required this.entry,
    required this.canPlant,
    this.potCol,
    this.potRow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantData = PlantData.getById(entry.plantDataName)!;

    return ListTile(
      leading: Image.asset(plantData.imagePath, width: 40),
      title: Text("Tier ${entry.tier} ${plantData.name}"),
      subtitle: Text('Quantity: ${entry.quantity}'),
      trailing: canPlant && potCol != null && potRow != null
          ? ElevatedButton(
              onPressed: () {
                // Access the GameStateManager directly via Riverpod
                final manager = ref.read(gameStateManagerProvider);
                // Create a PlantInstance from entry (adjust as needed)
                final plantInstance = PlantInstance(
                  plantDataName: entry.plantDataName,
                  tier: entry.tier,
                );
                manager.plantInPot(potRow!, potCol!, plantInstance);
                manager.removeFromInventory(entry);
              },
              child: const Text('Plant'),
            )
          : null,
    );
  }
}
