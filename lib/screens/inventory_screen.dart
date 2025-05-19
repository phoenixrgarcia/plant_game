import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';

import '../components/UI/inventory_list_item.dart';

class InventoryScreen extends StatefulWidget {
  final VoidCallback onClose;
  final void Function(InventoryEntry entry) onPlant;
  final List<InventoryEntry> plantInventory;

  const InventoryScreen({
    super.key,
    required this.onClose,
    required this.plantInventory,
    required this.onPlant,
  });

  @override
  State<InventoryScreen> createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  late List<InventoryEntry> _plantInventory;

  @override
  void initState() {
    super.initState();
    _plantInventory = widget.plantInventory;
  }

  void updateInventory(List<InventoryEntry> newInventory) {
    setState(() {
      _plantInventory = newInventory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: true,
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
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
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _plantInventory.length,
                      itemBuilder: (context, index) {
                        return InventoryListItem(
                          entry: _plantInventory[index],
                          onPlant: widget.onPlant,
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
