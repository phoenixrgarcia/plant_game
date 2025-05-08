import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:hive/hive.dart';

import '../components/pot_sprite.dart';

// This file containst he game logic for the greenhouse world. It loads the state and populates the pots.

class GreenhouseWorld extends World with HasGameRef<PlantGame> {
  late final List<List<PotSprite>> gardenPots = [];
  late List<List<PotState>> savedPots = [];

  List<List<PotSprite>> get pots => gardenPots;

  @override
  Future<void> onLoad() async {
// Load the saved game state
    var gameState = GameStateManager.currentState;
    savedPots = gameState.pots;

    // Check if saved pots exist, else create new pots
    if (savedPots[0].isEmpty) {
      addInitialGardenSpots();
    } else {
      addSavedGardenSpots();
    }
  }

  // Add pots from saved state
  void addSavedGardenSpots() {
    for (var potRow in savedPots) {
      gardenPots.add([]);
      for (var pot in potRow) {
        final potSprite = PotSprite(
          potState: pot,
          size: Vector2(80, 80),
        );
        add(potSprite);
        gardenPots[gardenPots.length - 1].add(potSprite);
      }
    }
  }

  void addInitialGardenSpots() {
    final Vector2 screenSize = gameRef.size;
    const int rows = 1;
    const int cols = 3;

    // Pot size based on screen width
    final double potSize = gameRef.potSize.x;
    final double spacing = (screenSize.x - (cols * potSize)) / (cols + 1);

    gardenPots.add([]);

    for (int col = 0; col < cols; col++) {
      final double x = col * (potSize + spacing) + spacing;
      final double y = (screenSize.y * 0.5) - (potSize / 2);

      final pot = PotSprite(
        potState: PotState(x: x, y: y),
        size: Vector2(potSize, potSize),
      );

      add(pot);
      gardenPots[0].add(pot);
    }
  }
}
