import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pair/pair.dart';
import 'package:plant_game/components/UI/floating_text.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:hive/hive.dart';

import '../components/plants/data/inventory_entry.dart';
import '../components/sprites/pot_sprite.dart';
import '../components/sprites/purchasable_pot_sprite.dart';

import 'package:plant_game/components/plants/plant_aoe_map.dart';

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

  void tickPot(PotState potState) {
    double deltaMoney = 0; // Reset delta money for this tick

    if (potState.currentPlant == null) return;

    if (potState.currentPlant!.currentAge == 0) {
      //trigger this plant's persistent effect on other plants
      //extract method?
      if (potState.currentPlant!.plantData.persistentEffect != null) {
        for (var dir in PlantAoeMap[
            potState.currentPlant!.plantData.persistentEffectAOE]!) {
          var newRow = potState.row + dir[0];
          var newCol = potState.col + dir[1];
          var neighboringPot = gameStateManager.getPot(newRow, newCol);
          if (neighboringPot == null) continue;
          if (neighboringPot.currentPlant == null) continue;
          potState.currentPlant!.plantData.persistentEffect!(neighboringPot,
              gameStateManager); //applies this plant effect to other plant
        }
      }

      //trigger other persistent effects on this plant
      //extract method?
      for (var otherPot in pots) {
        var otherPlant = otherPot.potState.currentPlant;
        if (otherPlant == null) continue;
        if (!otherPlant.isFullyGrown) continue;
        if (otherPlant.plantData.persistentEffectAOE == 'none') continue;

        for (var dir
            in PlantAoeMap[otherPlant.plantData.persistentEffectAOE]!) {
          var affectedRow = otherPot.potState.row + dir[0];
          var affectedCol = otherPot.potState.col + dir[1];
          if (affectedRow == potState.row &&
              affectedCol == potState.col &&
              otherPlant.plantData.persistentEffect != null) {
            // This plant is affected by the other plant's AOE effect
            otherPlant.plantData.persistentEffect!(potState, gameStateManager);
          }
        }
      }
    }

    potState.currentPlant!.incrementAge();

    //if plant is fully grown
    if (potState.currentPlant!.isFullyGrown) {
      //trigger tick effect
      potState.currentPlant!.plantData.onTick(potState, gameStateManager);

      //add particle effect for tick effect
      if (potState.currentPlant!.plantData.onTickAOE != 'none') {
        for (var dir
            in PlantAoeMap[potState.currentPlant!.plantData.onTickAOE]!) {
          var newRow = potState.row + dir[0];
          var newCol = potState.col + dir[1];
          var otherPot = pots
              .where(
                  (p) => p.potState.row == newRow && p.potState.col == newCol)
              .firstOrNull;
          if (otherPot == null)
            continue;
          else if (!otherPot.potState.isOccupied) continue;
          add(ParticleSystemComponent(
            particle: SpriteParticle(
              sprite: Sprite(gameRef.images.fromCache('star_particle.png')),
              size: Vector2(200, 200),
              lifespan: 2,
              
            ),
          ));
        }
      }

      // Add money for tick
      num currIncome = potState.currentPlant!.plantData.incomeRate +
          potState.currentPlant!.addBonus;
      currIncome = currIncome * (1 + potState.currentPlant!.multBonus);
      currIncome = pow(currIncome, 1 + potState.currentPlant!.exponentialBonus);
      currIncome = currIncome + potState.currentPlant!.flatBonus;
      currIncome = currIncome *
          (1 +
              0.1 *
                  (potState.currentPlant!.tier +
                      gameStateManager.getUpgradeLevel(
                          potState.currentPlant!.plantData.type, 'tier') -
                      1));
      print('Income for ${potState.currentPlant!.plantData.name}: $currIncome');
      deltaMoney += currIncome;
    }

    //update money
    if (deltaMoney != 0) {
      gameStateManager.mutateMoney(deltaMoney);
      add(FloatingText(
        position: calculatePotPosition(potState.row, potState.col),
        text: '\$${deltaMoney.toStringAsFixed(2)}',
      ));
    }
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
    //Update the game state based on changes in the GameStateManager

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

      for (Pair position in positions) {
        final key = '${position.key},${position.value}';
        if (!existingPositions.contains(key) &&
            !purchasablePotCoordinates.contains(key) &&
            position.key >= 0 &&
            position.value >= 0 &&
            position.key < 10 &&
            position.value < 10) {
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
