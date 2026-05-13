import 'package:hive/hive.dart';

part 'shop_state.g.dart';

@HiveType(typeId: 4)
class ShopState extends HiveObject {
  @HiveField(0)
  Map<String, bool> unlockedPlantTypes;

  @HiveField(1)
  Map<String, int> seedTierUpgradeLevel;

  @HiveField(2)
  Map<String, List<int>> seedCostMap;

  ShopState({
    Map<String, bool>? unlockedPlantTypes,
    Map<String, int>? seedTierUpgradeLevel,
    Map<String, List<int>>? seedCostMap,
  })  : unlockedPlantTypes =
            unlockedPlantTypes ?? {'Crop': true, 'Tree': true, 'Flower': false},
        seedTierUpgradeLevel =
            seedTierUpgradeLevel ?? {'Crop': 2, 'Tree': 2, 'Flower': 2},
        seedCostMap = seedCostMap ??
            {
              'Crop': [3, 8, 18],
              'Tree': [3, 8, 18],
              'Flower': [3, 8, 18]
            };
}
