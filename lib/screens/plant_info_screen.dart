import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';

import '../components/UI/inventory_list_item.dart';
import '../components/pot_sprite.dart';
import '../game_state_provider.dart';

class PlantInfoScreen extends ConsumerWidget {
  final VoidCallback onClose;
  final ValueNotifier<PotSprite?> selectedPotNotifier;

  const PlantInfoScreen({
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
        Positioned(
          top: MediaQuery.of(context).size.height * 0.13, // Adjust this value to account for the headerbar height in plant_game
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).size.height * 0.05 // Adjust this value to account for the game_ui height
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Plant Data",
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
                ]
              ),
            ),
          ),
        ),
      ],
    );
  }
}
