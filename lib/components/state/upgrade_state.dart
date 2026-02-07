import 'dart:math' as math;

import 'package:hive/hive.dart';
import 'package:plant_game/game_state_manager.dart';

part 'upgrade_state.g.dart';

@HiveType(typeId: 5)
class UpgradeState extends HiveObject {
  @HiveField(0)
  Map<String, Map<String, int>> upgradesPurchased;

  @HiveField(1)
  Map<String, Map<String, int>> upgradesCost;

  final costFunctions = {
    'tier': (int currentCost) => currentCost * 2,
    'speed': (int currentCost) => math.pow(currentCost, 1.2).toInt(),
  };

  UpgradeState({
    Map<String, Map<String, int>>? upgradesPurchased,
    Map<String, Map<String, int>>? upgradesCost,
  }) : upgradesPurchased = upgradesPurchased ?? {
          'Crop': {'tier': 0, 'speed': 0},
          'Tree': {'tier': 0, 'speed': 0},
          'Flower': {'tier': 0, 'speed': 0},
  },    upgradesCost = upgradesCost ?? {
          'Crop': {'tier': 20, 'speed': 30},
          'Tree': {'tier': 20, 'speed': 30},
          'Flower': {'tier': 20, 'speed': 30},
  };

  void applyUpgrade(String category, String upgradeType) {
    if (upgradesPurchased.containsKey(category) && upgradesPurchased[category]!.containsKey(upgradeType)) {
      upgradesPurchased[category]![upgradeType] = upgradesPurchased[category]![upgradeType]! + 1;
      upgradesCost[category]![upgradeType] = costFunctions[upgradeType]!(upgradesCost[category]![upgradeType]!);

      if(upgradeType == 'speed') {
        GameStateManager().applySpeedUpgrade(category);
      }
    }
  }
}