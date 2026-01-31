import 'package:hive/hive.dart';

part 'upgrade_state.g.dart';

@HiveType(typeId: 5)
class UpgradeState extends HiveObject {
  @HiveField(0)
  Map<String, Map<String, int>> upgradesPurchased;

  UpgradeState({
    Map<String, Map<String, int>>? upgradesPurchased,
  }) : upgradesPurchased = upgradesPurchased ?? {
          'Crop': {'tier': 0, 'speed': 0},
          'Tree': {'tier': 0, 'speed': 0},
          'Flower': {'tier': 0, 'speed': 0},
  };
}