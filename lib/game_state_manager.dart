import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/plants/plant_instance.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:flutter/foundation.dart';

class GameStateManager extends ChangeNotifier {
  // Singleton boilerplate
  static final GameStateManager _instance = GameStateManager._internal();
  factory GameStateManager() => _instance;
  GameStateManager._internal();

  static const _boxName = 'gameState';
  static const _key = 'currentGameState';

  Box<GameState>? _box;
  late GameState _currentState;

  GameState get state => _currentState;

  /// Initializes Hive, registers adapters, opens the box, and loads state
  Future<void> init() async {
    // Register adapters once
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(GameStateAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(PotStateAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(InventoryEntryAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(PlantInstanceAdapter());

    // Open the Hive box
    _box = await Hive.openBox<GameState>(_boxName);

    // Load current state or initialize default
    _currentState = _box!.get(_key) ??
        GameState(
          money: 0,
          pots: [[PotState(row: 0, col: 0)]],
          plantInventory: [
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 1),
          ],
        );
  }

  /// Saves the current state to Hive
  Future<void> save() async {
    if (_box == null) {
      throw Exception("GameStateManager not initialized.");
    }
    await _box!.put(_key, _currentState);
  }

  /// Replaces and saves new state
  Future<void> update(GameState newState) async {
    _currentState = newState;
    await save();
    notifyListeners(); // Notify listeners of state change
  }

  /// Clears game state from disk (used for reset)
  Future<void> clear() async {
    await _box?.delete(_key);
    _currentState = GameState(
      money: 0,
      pots: [[]],
      plantInventory: [],
    );
  }

  /// Example mutator for money
  void addMoney(int amount) {
    _currentState.money += amount;
    notifyListeners(); // Notify listeners of state change
  }

  /// Example mutator for planting in a pot
  void plantInPot(int x, int y, PlantInstance plant) {
    // TODO
    //_currentState.pots[x][y].currentPlant = plant;
  }
}
