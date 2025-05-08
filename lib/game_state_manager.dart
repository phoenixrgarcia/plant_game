import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/crop_data.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/state/game_state.dart';

class GameStateManager {
  static Box<GameState>? _box;

  static Future<void> init() async {
    // Register the adapter if not done already (you only need to register once)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GameStateAdapter());
    }

    _box = await Hive.openBox<GameState>('gameState');
  }

  static Box<GameState> get box {
    if (_box == null) {
      throw Exception("GameStateManager is not initialized.");
    }
    return _box!;
  }

  static GameState get currentState {
    return box.get('currentGameState') ??
        GameState(money: 0, pots: [[]], plantInventory: [InventoryEntry(plant: cropData.firstWhere((c) => c.name == "Tomato"), quantity: 1)]); // Default fallback
  }

  static void saveState(GameState state) {
    box.put('currentGameState', state);
  }

  static void clearState() {
    box.delete('currentGameState');
  }
}
