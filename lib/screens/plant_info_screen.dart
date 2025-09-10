import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';

import '../components/UI/inventory_list_item.dart';
import '../components/sprites/pot_sprite.dart';
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
    return Stack(
      children: [
        IgnorePointer(
          ignoring: true,
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.13, // Adjust this value to account for the headerbar height in plant_game
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).size.height *
                      0.05 // Adjust this value to account for the game_ui height
                  ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<PotSprite?>(
                    valueListenable: selectedPotNotifier,
                    builder: (context, selectedPot, _) {
                      final plant = selectedPot?.potState.currentPlant;
                      if (plant == null) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "No plant selected.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      final plantData = PlantData.getById(plant.plantDataName);
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plantData?.name ?? plant.plantDataName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Tier: ${plant.tier}",
                                  style: const TextStyle(fontSize: 16)),
                              Text("Age: ${plant.currentAge} ticks",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Harvest Value: \$${plantData?.sellPrice ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Income Rate: \$${plantData?.incomeRate ?? 'N/A'}/tick",
                                  style: const TextStyle(fontSize: 16)),
                              if (true /*plantData?.specialProperties != null && plantData!.specialProperties.isNotEmpty*/)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Special: ${plantData?.specialProperties ?? 'None'}",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.deepPurple),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
                        ValueListenableBuilder<PotSprite?>(
                          valueListenable: selectedPotNotifier,
                          builder: (context, selectedPot, _) {
                            final plant = selectedPot?.potState.currentPlant;
                            if (plant == null) {
                              // No plant selected, return empty widget
                              return const SizedBox.shrink();
                            }
                            final plantData =
                                PlantData.getById(plant.plantDataName);
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Harvest Plant?'),
                                    content: Text(
                                        'Harvest this plant for \$${plantData?.sellPrice ?? 'N/A'}?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel')),
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Harvest')),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  gameStateManager.harvestPlant(
                                      selectedPot!.potState.row,
                                      selectedPot.potState.col);
                                  onClose(); // Close the plant info screen
                                }
                              },
                              child: Text(
                                  'Harvest \$${plantData?.sellPrice ?? 'N/A'}'),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onClose,
                        ),
                      ],
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
