import 'package:hive/hive.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/plants/plant_instance.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/components/state/shop_state.dart';
import 'package:plant_game/components/state/upgrade_state.dart';

part 'game_state.g.dart';


@HiveType(typeId: 0)
class GameState extends HiveObject {
  @HiveField(0)
  double money;

  @HiveField(1)
  List<PotState> pots;

  @HiveField(2)
  List<InventoryEntry> plantInventory;

  @HiveField(3)
  double potCost;

  @HiveField(4)
  int nextShopRandomSeed;

  @HiveField(5)
  ShopState shopState;

  @HiveField(6)
  UpgradeState upgradeState;

  GameState(
      {this.money = 0,
      required this.pots,
      required this.plantInventory,
      this.potCost = 25,
      this.nextShopRandomSeed = 0,
      required this.shopState,
      required this.upgradeState});
}
