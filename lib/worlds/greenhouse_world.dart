import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:hive/hive.dart';

import '../components/plants/data/inventory_entry.dart';
import '../components/pot_sprite.dart';

// This file containst he game logic for the greenhouse world. It loads the state and populates the pots.

class GreenhouseWorld extends World with HasGameRef<PlantGame> {
  final GameStateManager gameStateManager;
  late final List<List<PotSprite>> gardenPots = [];
  late List<List<PotState>> savedPots = [];

  ValueNotifier<PotSprite?> selectedPot = ValueNotifier(null);

  List<List<PotSprite>> get pots => gardenPots;

  GreenhouseWorld({required this.gameStateManager});

  @override
  Future<void> onLoad() async {
    // Load the saved game state
    gameStateManager.addListener(_onGameStateChanged);

    setGardenPots();
  }

  // Add pots from saved state
  void setGardenPots() {
    for (var potRow in gameStateManager.state.pots) {
      gardenPots.add([]);
      for (var pot in potRow) {
        final potSprite = PotSprite(
          potState: pot,
          size: Vector2(80, 80),
          position: calculatePotPosition(pot.row, pot.col)
        );
        add(potSprite);
        gardenPots[gardenPots.length - 1].add(potSprite);
      }
    }
  }

  // TODO remove this
  // void addInitialGardenSpots() {
  //   final Vector2 screenSize = gameRef.size;
  //   const int rows = 1;
  //   const int cols = 3;

  //   // Pot size based on screen width
  //   final double potSize = gameRef.potSize.x;
  //   final double spacing = (screenSize.x - (cols * potSize)) / (cols + 1);

  //   gardenPots.add([]);

  //   for (int col = 0; col < cols; col++) {
  //     final double x = col * (potSize + spacing) + spacing;
  //     final double y = (screenSize.y * 0.5) - (potSize / 2);

  //     final pot = PotSprite(
  //       potState: PotState(x: x, y: y),
  //       size: Vector2(potSize, potSize),
  //     );

  //     add(pot);
  //     gardenPots[0].add(pot);
  //   }

  //   for (var potRow in gardenPots) {
  //     for (var pot in potRow) {
  //       savedPots[0].add(pot.potState);
  //     }
  //   }

  //   final updatedState = GameState(
  //     money: GameStateManager.currentState.money,
  //     pots: savedPots,
  //     plantInventory: GameStateManager.currentState.plantInventory,
  //   );

  //   GameStateManager.saveState(updatedState);

  // }

  void selectPot(PotSprite pot) {
    selectedPot.value = pot;
    // Additional logic for selecting a pot
  }

  void deselectPot() {
    selectedPot.value = null;
    // Additional logic for deselecting a pot
  }

  // void plant(InventoryEntry entry) {
  //   if (selectedPot.value != null &&
  //       entry.quantity > 0 &&
  //       selectedPot.value!.potState.isOccupied == false) {
  //     selectedPot.value!.potState.plant(entry);
  //     selectedPot.value?.updatePlantSprite();
  //     var state = GameStateManager.currentState;
  //     state.plantInventory
  //         .where((e) => e.plantDataName == entry.plantDataName)
  //         .first
  //         .quantity -= 1;

  //     savedPots[0][gardenPots[0].indexOf(selectedPot.value!)] =
  //         selectedPot.value!.potState;
  //     state.pots = savedPots;
  //     selectedPot.value = null; // Deselect after planting
  //     GameStateManager.saveState(state); // Save the game state after planting
  //   } else {
  //     print("Issue planting the plant.");
  //   }
  // }

  void tick() {
    // Iterate through all pots and call their tick method

    //a list to store the multiplication values for each pot, that is NxM the same size as gardenPots
    List<List<double>> multValues = List.generate(
        gardenPots.length, (i) => List.filled(gardenPots[i].length, 1.0));

    for (var potRow in pots) {
      for (var pot in potRow) {
        if (pot.potState.currentPlant != null) {
          // Call the tick method on the plant instance
          pot.potState.currentPlant!.incrementAge();
        }
      }
    }
  }

  Vector2 calculatePotPosition(int row, int col) {
    final Vector2 screenSize = gameRef.size;
    final double potSize = gameRef.potSize.x;
    final double spacing = (screenSize.x - (3 * potSize)) / (3 + 1);

    final double x = col * (potSize + spacing) + spacing;
    final double y =
        row * (potSize + spacing) + (screenSize.y * 0.5) - (potSize / 2);

    return Vector2(x, y);
  }

  void _onGameStateChanged() {
    // Update your Flame components here, e.g.:
    // - Update pot sprites if pots changed
    // - Update UI overlays if money changed
  }
}
