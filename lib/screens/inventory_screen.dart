import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';

// This screen is a flutter widget instead of a flame component.
// This screen displays the player's inventory.
//

class InventoryScreen extends StatelessWidget {
  final VoidCallback onClose;
  final List<InventoryEntry> plantInventory;

  InventoryScreen({super.key, required this.onClose, required this.plantInventory});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // This makes the rest of the screen transparent and pass-through
        IgnorePointer(
          ignoring: true,
          child: Container(
            color: Colors.transparent,
          ),
        ),

        // Inventory panel that blocks touches only in this area
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            // Needed for Material widgets like ListTile
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Inventory",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ),

                  // Inventory List
                  Expanded(
                    child: ListView.builder(
                      itemCount: plantInventory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.shopping_bag),
                          title: Text(plantInventory[index].plant.name),
                          subtitle: Text("Quantity: ${plantInventory[index].quantity}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
