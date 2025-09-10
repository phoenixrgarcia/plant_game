import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:pair/pair.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:hive/hive.dart';

import '../components/plants/data/inventory_entry.dart';
import '../components/sprites/pot_sprite.dart';
import '../components/sprites/purchasable_pot_sprite.dart';

// This file containst he game logic for the greenhouse world. It loads the state and populates the pots.

class GreenhouseWorld extends World with HasGameRef<PlantGame> {
  final GameStateManager gameStateManager;
  late final Set<PotSprite> gardenPots = {};
  late final Set<PurchasablePot> purchasablePots = {};
  late final Set<String> purchasablePotCoordinates = {};

  ValueNotifier<PotSprite?> selectedPot = ValueNotifier(null);

  Set<PotSprite> get pots => gardenPots;

  GreenhouseWorld({required this.gameStateManager});

  late Vector2 potSize;

  late int? pendingPotRow;
  late int? pendingPotCol;

  @override
  Future<void> onLoad() async {
    // Load the saved game state
    gameStateManager.addListener(_onGameStateChanged);
    potSize = gameRef.potSize;

    setGardenPots();
    addPurchasablePots();
  }

  // Add pots from saved state
  void setGardenPots() {
    gardenPots.clear();

    for (var pot in gameStateManager.state.pots) {
      final potSprite = PotSprite(
          potState: pot,
          size: potSize,
          position: calculatePotPosition(pot.row, pot.col));
      add(potSprite);
      gardenPots.add(potSprite);
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
    // List<List<double>> multValues = List.generate(
    //     gardenPots.length, (i) => List.filled(gardenPots[i].length, 1.0));

    double deltaMoney = 0; // Reset delta money for this tick

    for (var pot in pots) {
      if (pot.potState.currentPlant != null) {
        // Call the tick method on the plant instance
        pot.potState.currentPlant!.incrementAge();
      }
    }

    // Iterate through each pot and apply the multimutation values
    // for(var pot in potStates) {
    //     if (pot.currentPlant != null) {
    //       pot.currentPlant!.mutateMultValues(multValues, potStates);
    //     }
    // }

    for (var pot in gardenPots) {
      if (pot.potState.currentPlant != null) {
        // If the plant is fully grown, we can harvest it
        if (pot.potState.currentPlant!.isFullyGrown) {
          // Add money for harvesting
          deltaMoney += pot.potState.currentPlant!.plantData.incomeRate *
              1; //TODO multValues[pot.potState.col][pot.potState.row];
        }
      }
    }

    // Update the game state with the new money value
    if (deltaMoney != 0) {
      gameStateManager.mutateMoney(deltaMoney);
    }
    gameStateManager.notify(); // Notify listeners of state change
  }

  //Helper function to calculate the position of a pot based on its row and column
  Vector2 calculatePotPosition(int row, int col) {
    final Vector2 screenSize = gameRef.size;
    final double potSize = gameRef.potSize.x;
    final double spacing = (screenSize.x - (3 * potSize)) / (3 + 1);

    final double x =
        col * (potSize + spacing) + (screenSize.x * 0.5) - (potSize / 2);
    final double y =
        row * (potSize + spacing) + (screenSize.y * 0.5) - (potSize / 2);

    return Vector2(x, y);
  }

  void purchasePot(int row, int col) {
    final potCost = gameStateManager.state.potCost;
    if (gameStateManager.state.money >= potCost) {
      // Deduct money
      gameStateManager.mutateMoney(-potCost);

      // Add new pot to the game state
      final newPot = PotState(row: row, col: col);
      gameStateManager.state.pots.add(newPot);
      gameStateManager.save();

      // Add new pot sprite to the world
      final potSprite = PotSprite(
          potState: newPot,
          size: potSize,
          position: calculatePotPosition(row, col));

      remove(purchasablePots.firstWhere((p) => p.row == row && p.col == col));
      purchasablePotCoordinates.remove('$row,$col');
      purchasablePots.removeWhere((p) => p.row == row && p.col == col);
      add(potSprite);
      gardenPots.add(potSprite);
      gameStateManager.incrementPotPrice();
      addPurchasablePots();
    }
  }

  void _onGameStateChanged() {
    // Update the game state based on changes in the GameStateManager
    for (var pot in gardenPots) {
      // Update each pot's state if needed
      final savedPot = gameStateManager.state.pots
          .where((p) => p.row == pot.potState.row && p.col == pot.potState.col)
          .first;
      pot.potState = savedPot;
      pot.updatePlantSprite(); // Update the sprite if the plant has changed
    }
    // Update your Flame components here, e.g.:
    // - Update pot sprites if pots changed
    // - Update UI overlays if money changed
  }

  void addPurchasablePots() {
    Set<String> existingPositions =
        gameStateManager.state.pots.map((p) => '${p.row},${p.col}').toSet();

    for (var pot in gameStateManager.state.pots) {
      final positions = [
        Pair(pot.row - 1, pot.col),
        Pair(pot.row + 1, pot.col),
        Pair(pot.row, pot.col - 1),
        Pair(pot.row, pot.col + 1)
      ];

      for(Pair position in positions){
        final key = '${position.key},${position.value}';
        if(!existingPositions.contains(key) && !purchasablePotCoordinates.contains(key) && position.key >=0 && position.value >=0){
          final purchasablePot = PurchasablePot(
            size: potSize,
            row: position.key,
            col: position.value,
            position: calculatePotPosition(position.key, position.value),
          );
          add(purchasablePot);
          purchasablePotCoordinates.add(key);
          purchasablePots.add(purchasablePot);
        }
      }
    }
  }
}
