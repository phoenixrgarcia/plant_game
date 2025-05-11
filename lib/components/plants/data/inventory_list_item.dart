import 'package:flutter/material.dart';

import 'inventory_entry.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryEntry entry;
  final void Function(InventoryEntry entry) onPlant;

  const InventoryListItem({required this.entry, required this.onPlant});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(entry.plant.spritePath, width: 40),
      title: Text(entry.plant.name),
      subtitle: Text('Quantity: ${entry.quantity}'),
      trailing: ElevatedButton(onPressed: () => onPlant(entry), child: const Text('Plant')),
    );
  }
}
