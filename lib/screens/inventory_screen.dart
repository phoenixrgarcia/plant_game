import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';

import '../components/UI/inventory_list_item.dart';
import '../components/sprites/pot_sprite.dart';
import '../game_state_provider.dart';

class InventoryScreen extends ConsumerWidget {
  final VoidCallback onClose;
  final ValueNotifier<PotSprite?> selectedPotNotifier;

  const InventoryScreen({
    super.key,
    required this.onClose,
    required this.selectedPotNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateManager = ref.watch(gameStateManagerProvider);
    final plantInventory = gameStateManager.state.plantInventory;
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
              padding: EdgeInsetsDirectional.only(
                bottom: 60 // Adjust this value to account for the NavBar height
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                  Expanded(
                    child: ValueListenableBuilder<PotSprite?>(
                      valueListenable: selectedPotNotifier,
                      builder: (context, selectedPot, _) {
                        final canPlant = selectedPot != null && selectedPot.potState.isOccupied == false;
                        return ListView.builder(
                          itemCount: plantInventory.length,
                          itemBuilder: (context, index) {
                            return InventoryListItem(
                              entry: plantInventory[plantInventory.length - 1 - index],
                              canPlant: canPlant,
                              potRow: selectedPot?.potState.row,
                              potCol: selectedPot?.potState.col,
                              onClose: onClose,
                            );
                          },
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
