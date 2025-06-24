import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';

import '../plants/data/inventory_entry.dart';

class InventoryListItem extends StatefulWidget {
  final InventoryEntry entry;
  final void Function(InventoryEntry entry) onPlant;
  final bool canPlant; // 👈 passed from outside

  const InventoryListItem({
    super.key,
    required this.entry,
    required this.onPlant,
    required this.canPlant,
  });

  @override
  State<InventoryListItem> createState() => _InventoryListItemState();
}

class _InventoryListItemState extends State<InventoryListItem> {
  @override
  Widget build(BuildContext context) {
    final plantData = PlantData.getById(widget.entry.plantDataName)!;

    return ListTile(
      leading: Image.asset(plantData.imagePath, width: 40),
      title: Text("Tier ${widget.entry.tier} ${plantData.name}"),
      subtitle: Text('Quantity: ${widget.entry.quantity}'),
      trailing: widget.canPlant
          ? ElevatedButton(
              onPressed: () => widget.onPlant(widget.entry),
              child: const Text('Plant'),
            )
          : null,
    );
  }
}
