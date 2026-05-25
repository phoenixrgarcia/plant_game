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
  final VoidCallback? onClose;

  const InventoryListItem({
    super.key,
    required this.entry,
    required this.canPlant,
    this.potCol,
    this.potRow,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget? trailingWidget;
    Widget? plantedWidget;
    Widget? tierWidget;
    final plantData = PlantData.getById(entry.plantDataName)!;

    // Plant button widget, or planted text
    if (canPlant &&
        potCol != null &&
        potRow != null &&
        entry.isPlanted == false) {
      plantedWidget = ElevatedButton(
        onPressed: () {
          final manager = ref.read(gameStateManagerProvider);
          final plantInstance = PlantInstance(
            plantDataName: entry.plantDataName,
            tier: entry.tier,
          );

          manager.plantInPot(potRow!, potCol!, plantInstance);
          manager.plantFromInventory(entry);
          onClose?.call();
        },
        child: const Text('Plant'),
      );
    } else if (entry.isPlanted == true) {
      plantedWidget = const Text('Planted');
    } else {
      plantedWidget = null;
    }

    // Tier display and button
    if (entry.canTierUp) {
      tierWidget = ElevatedButton(
        onPressed: () {
          final manager = ref.read(gameStateManagerProvider);
          entry.tierUp();
          manager.save(); // Save state after mutating
          manager.notifyListeners(); // Notify listeners of state change
        },
        child: const Text('Upgrade Tier'),
      );
    } else {
      tierWidget = null;
    }

    trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [tierWidget ?? SizedBox.shrink(), plantedWidget!]);

    return ListTile(
        leading: Image.asset(plantData.imagePath, width: 40),
        title: Text("Tier ${entry.tier} ${plantData.name}"),
        subtitle:
            Text('Copies: ${entry.totalCopies} / ${entry.copiesToNextTier}'),
        trailing: trailingWidget);
  }
}
