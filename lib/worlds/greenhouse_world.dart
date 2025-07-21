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
  late List<List<PotState>> potStates = [];

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
    potStates = gameStateManager.state.pots;
    gardenPots.clear();

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

  void selectPot(PotSprite pot) {
    selectedPot.value = pot;
    // Additional logic for selecting a pot
  }

  void deselectPot() {
    selectedPot.value = null;
    // Additional logic for deselecting a pot
  }

  void tick() {
    // Iterate through all pots and call their tick method
    // Doing this in this order to follow PEMDAS logic
    //a list to store the multiplication values for each pot, that is NxM the same size as gardenPots
    List<List<double>> multValues = List.generate(
        gardenPots.length, (i) => List.filled(gardenPots[i].length, 1.0));

    double deltaMoney = 0; // Reset delta money for this tick

    for (var potRow in pots) {
      for (var pot in potRow) {
        if (pot.potState.currentPlant != null) {
          // Call the tick method on the plant instance
          pot.potState.currentPlant!.incrementAge();
        }
      }
    }

    // Iterate through each pot and apply the multimutation values
    for(var potRow in potStates) {
      for (var pot in potRow) {
        if (pot.currentPlant != null) {
          pot.currentPlant!.mutateMultValues(multValues, potStates);
        }
      }
    }

    for(var potRow in gardenPots) {
      for (var pot in potRow) {
        if (pot.potState.currentPlant != null) {
          // If the plant is fully grown, we can harvest it
          if (pot.potState.currentPlant!.isFullyGrown) {
            // Add money for harvesting
            deltaMoney += pot.potState.currentPlant!.plantData.incomeRate * multValues[pot.potState.col][pot.potState.row];
          }
        }
      }
    }

    // Update the game state with the new money value
    if (deltaMoney != 0) {
      gameStateManager.mutateMoney(deltaMoney);
    }

  }

  //Helper function to calculate the position of a pot based on its row and column
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
    // Update the game state based on changes in the GameStateManager
    for (var potRow in gardenPots) {
      for (var pot in potRow) {
        // Update each pot's state if needed
        final savedPot = gameStateManager.state.pots[pot.potState.col][pot.potState.row];
        pot.potState = savedPot;
        pot.updatePlantSprite(); // Update the sprite if the plant has changed
      }
    }
    // Update your Flame components here, e.g.:
    // - Update pot sprites if pots changed
    // - Update UI overlays if money changed
  }
}
