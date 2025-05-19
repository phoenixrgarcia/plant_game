import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/plants/plant_instance.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';

class GameStateManager {
  static Box<GameState>? _box;

  static Future<void> init() async {
    // Register the adapter if not done already (you only need to register once)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GameStateAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PotStateAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(InventoryEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(PlantInstanceAdapter());
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
        GameState(money: 0, pots: [[]], plantInventory: [InventoryEntry(plantDataName: 'tomato', quantity: 1)]); // Default fallback
  }

  static void saveState(GameState state) {
    box.put('currentGameState', state);
  }

  static void clearState() {
    box.delete('currentGameState');
  }
}
