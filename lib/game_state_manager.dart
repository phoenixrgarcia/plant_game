import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/plants/plant_instance.dart';
import 'package:plant_game/components/state/economy_state.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:flutter/foundation.dart';
import 'package:plant_game/components/state/shop_state.dart';
import 'package:plant_game/components/state/upgrade_state.dart';

import 'components/state/investor_state.dart';

class GameStateManager extends ChangeNotifier {
  // Singleton boilerplate
  static final GameStateManager _instance = GameStateManager._internal();
  factory GameStateManager() => _instance;
  GameStateManager._internal();

  static const _boxName = 'gameState';
  static const _key = 'currentGameState';

  Box<GameState>? _box;
  late GameState _gameState;

  late EconomyState _economyState;

  GameState get state => _gameState;
  EconomyState get economyState => _economyState;

  /// Initializes Hive, registers adapters, opens the box, and loads state
  Future<void> init() async {
    // Register adapters once
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(GameStateAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(PotStateAdapter());
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(InventoryEntryAdapter());
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(PlantInstanceAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ShopStateAdapter());
    if (!Hive.isAdapterRegistered(5))
      Hive.registerAdapter(UpgradeStateAdapter());
    if (!Hive.isAdapterRegistered(6))
      Hive.registerAdapter(InvestorStateAdapter());

    // Open the Hive box
    _box = await Hive.openBox<GameState>(_boxName);

    // Load current state or initialize default
    _gameState = _box!.get(_key) ??
        GameState(
          money: 100.0,
          pots: [PotState(row: 0, col: 0)],
          plantInventory: [
            InventoryEntry(plantDataName: 'Tomato', quantity: 1, tier: 1),
            InventoryEntry(plantDataName: 'Giving Tree', quantity: 1, tier: 1),
            InventoryEntry(plantDataName: 'Apple Tree', quantity: 1, tier: 1),
            InventoryEntry(plantDataName: 'Tomato', quantity: 1, tier: 2),
            InventoryEntry(plantDataName: 'Tomato', quantity: 1, tier: 3),
          ],
          potCost: 25.0,
          nextShopRandomSeed: 0,
          shopState: ShopState(),
          upgradeState: UpgradeState(),
          investorState: InvestorState(),
        );

    _economyState = EconomyState();
  }

  /// Saves the current state to Hive
  /// Call when, planting plant, harvesting, or changing inventory.
  Future<void> save() async {
    if (_box == null) {
      throw Exception("GameStateManager not initialized.");
    }
    await _box!.put(_key, _gameState);
  }

  /// Replaces and saves new state
  Future<void> update(GameState newState) async {
    _gameState = newState;
    await save();
    notifyListeners(); // Notify listeners of state change
  }

  /// Clears game state from disk (used for reset)
  Future<void> clear() async {
    await _box?.delete(_key);
    _gameState = GameState(
      money: 0,
      pots: [],
      plantInventory: [],
      potCost: 25,
      nextShopRandomSeed: 0,
      shopState: ShopState(),
      upgradeState: UpgradeState(),
      investorState: InvestorState(),
    );
  }

  /// Example mutator for money
  /// Probably dont actually use this, since money is frequently updated.
  void mutateMoney(double amount) {
    _gameState.money += amount;
    notifyListeners(); // Notify listeners of state change // comment this out?
  }

  void reportIncome(double amount) {
    _economyState.addIncomeTicks(amount);
  }

  void tickRuntimeEconomy() {
    _economyState.pruneOldIncomeTicks();

    checkAwardInvestor();
  }

  void checkAwardInvestor() {
    if (_economyState.incomeInLastMinute <
        _gameState.investorState.nextInvestorThreshold()) {
      _economyState.previousTimeBelowIncomeThreshold = DateTime.now();
    } else if (DateTime.now()
            .difference(_economyState.previousTimeBelowIncomeThreshold) >
        Duration(seconds: 15)) {
      _gameState.investorState.attractInvestor();
      _economyState.previousTimeBelowIncomeThreshold = DateTime.now();
      notifyListeners();
    }
  }

  /// Mutator for planting in a pot
  void plantInPot(int row, int col, PlantInstance plant) {
    final pot =
        _gameState.pots.where((p) => p.row == row && p.col == col).first;
    if (pot.isOccupied) {
      throw Exception("Pot at ($row, $col) is occupied.");
    }

    pot.currentPlant = plant;
    print("Planted ${plant.plantDataName} in pot at ($row, $col)");
    save(); // Save state after mutating
    notifyListeners(); // Notify listeners of state change
  }

  /// Harvests a plant from a specific pot
  void harvestPlant(int row, int col) {
    final pot =
        _gameState.pots.where((p) => p.row == row && p.col == col).first;
    if (pot.currentPlant == null) {
      throw Exception("No plant to harvest in pot at ($row, $col).");
    }
    mutateMoney(pot.currentPlant!.plantData.sellPrice);
    pot.currentPlant = null; // Remove the plant from the pot

    save(); // Save state after mutating
    notifyListeners(); // Notify listeners of state change
  }

  void removeFromInventory(InventoryEntry entry) {
    final index = _gameState.plantInventory.indexWhere(
        (e) => e.plantDataName == entry.plantDataName && e.tier == entry.tier);
    if (index != -1) {
      _gameState.plantInventory[index].quantity -= entry.quantity;
      if (_gameState.plantInventory[index].quantity <= 0) {
        _gameState.plantInventory.removeAt(index);
      }
      save(); // Save state after mutating
      notifyListeners(); // Notify listeners of state change
    } else {
      throw Exception("Entry not found in inventory: ${entry.plantDataName}");
    }
  }

  void addToInventory(Map<String, dynamic> entry) {
    //Entry is a map with keys: name, image, stats{tier}
    final index = _gameState.plantInventory.indexWhere((e) =>
        e.plantDataName == entry['name'] && e.tier == entry['stats']['tier']);
    if (index != -1) {
      _gameState.plantInventory[index].quantity += 1;
    } else {
      _gameState.plantInventory.add(InventoryEntry(
        plantDataName: entry['name'],
        quantity: 1,
        tier: entry['stats']['tier'],
      ));
    }
    save(); // Save state after mutating
    notifyListeners(); // Notify listeners of state change
  }

  void incrementPotPrice() {
    _gameState.potCost *= 1.15;
    save();
  }

  void notify() {
    notifyListeners();
  }

  void randomShopSeed() {
    _gameState.nextShopRandomSeed =
        DateTime.now().millisecondsSinceEpoch % 10000;
    save();
  }

  PotState? getPot(int row, int col) {
    try {
      return _gameState.pots.firstWhere((p) => p.row == row && p.col == col);
    } catch (_) {
      return null;
    }
  }

  bool purchaseUpgrade(String category, String upgradeName) {
    final cost = _gameState.upgradeState.upgradesCost[category]![upgradeName]!;
    if (_gameState.money >= cost) {
      _gameState.money -= cost;
      _gameState.upgradeState.applyUpgrade(category, upgradeName);
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  void applySpeedUpgrade(String category) {
    for (var pot in _gameState.pots) {
      if (pot.currentPlant != null &&
          pot.currentPlant!.plantData.type == category) {
        pot.currentPlant!.tickRateMult *=
            0.9; // Example: reduce growth time by 10%
      }
    }
  }

  int getUpgradeLevel(String category, String upgradeName) {
    return _gameState.upgradeState.upgradesPurchased[category]![upgradeName]!;
  }

  bool attemptPurchase(int cost) {
    if (_gameState.money >= cost) {
      _gameState.money -= cost;
      save();
      notifyListeners();
      return true;
    }
    return false;
  }
}
