import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:hive/hive.dart';

import '../components/pot_sprite.dart';

class GreenhouseWorld extends World 
    with HasGameRef<PlantGame> {
  late final List<List<PotSprite>> gardenPots = [];
  late List<PotState> savedPots;

  @override
  Future<void> onLoad() async {
// Load the saved game state
    var box = GameStateManager.box;
    var gameState = box.get('currentGameState', defaultValue: GameState(money: 0, pots: []));

    savedPots = gameState.pots;

    // Check if saved pots exist, else create new pots
    if (savedPots.isEmpty) {
      addInitialGardenSpots();
    } else {
      addSavedGardenSpots();
    }
  }

  // Add pots from saved state
  void addSavedGardenSpots() {
    for (var potState in savedPots) {
      final pot = PotSprite(
        potState: potState,
        size: Vector2(100, 100),  // Pot size remains fixed
      );

      add(pot);
      gardenPots[0].add(pot);
    }
  }

  void addInitialGardenSpots() {
    final Vector2 screenSize = gameRef.size;
    const int rows = 1;
    const int cols = 3;

    // Pot size based on screen width
    final double potSize = (screenSize.x * 0.65) / cols;
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
