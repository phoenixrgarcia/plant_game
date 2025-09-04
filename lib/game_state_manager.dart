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
          money: 100.0,
          pots: [[PotState(row: 0, col: 0)]],
          plantInventory: [
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 1),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 2),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 3),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 4),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 5),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 6),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 7),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 8),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 9),
            InventoryEntry(plantDataName: 'tomato', quantity: 1, tier: 10),
          ],
          potCost: 25.0,
        );
  }

  /// Saves the current state to Hive
  /// Call when, planting plant, harvesting, or changing inventory. 
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
  /// Probably dont actually use this, since money is frequently updated. 
  void mutateMoney(double amount) {
    _currentState.money += amount;
    notifyListeners(); // Notify listeners of state change // comment this out? 
  }

  /// Mutator for planting in a pot
  void plantInPot(int row, int col, PlantInstance plant) {
    if (row < 0 || col < 0 || row >= _currentState.pots.length || col >= _currentState.pots[row].length) {
      throw Exception("Invalid pot coordinates: ($row, $col)");
    }

    final pot = _currentState.pots[col][row];
    if (pot.isOccupied) {
      throw Exception("Pot at ($row, $col) is occupied.");
    }

    pot.currentPlant = plant;
    save(); // Save state after mutating
    notifyListeners(); // Notify listeners of state change
  }

  /// Harvests a plant from a specific pot
  void harvestPlant(int row, int col) {
    final pot = _currentState.pots[col][row];
    if (pot.currentPlant == null) {
      throw Exception("No plant to harvest in pot at ($row, $col).");
    }
    mutateMoney(pot.currentPlant!.plantData.sellPrice);
    pot.currentPlant = null; // Remove the plant from the pot
    
    save(); // Save state after mutating
    notifyListeners(); // Notify listeners of state change
  }

  void removeFromInventory(InventoryEntry entry) {
    final index = _currentState.plantInventory.indexWhere((e) => e.plantDataName == entry.plantDataName && e.tier == entry.tier);
    if (index != -1) {
      _currentState.plantInventory[index].quantity -= entry.quantity;
      if (_currentState.plantInventory[index].quantity <= 0) {
        _currentState.plantInventory.removeAt(index);
      }
      save(); // Save state after mutating
      notifyListeners(); // Notify listeners of state change
    } else {
      throw Exception("Entry not found in inventory: ${entry.plantDataName}");
    }
  }

  void incrementPotPrice(){
    _currentState.potCost *= 1.15;
    save();
  }

  void notify() {
    notifyListeners();
  }
}
