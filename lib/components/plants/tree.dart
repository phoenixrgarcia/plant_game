import 'plant.dart';

class Tree extends Plant {
  Tree({
    required String name,
    required int growthTime,
    required int sellPrice,
    required int incomeRate,
    required String spritePath,
    Function()? onHarvest,
    Function()? onTick,
  }) : super(
          name: name,
          growthTime: growthTime,
          sellPrice: sellPrice,
          incomeRate: incomeRate,
          spritePath: spritePath,
          onHarvest: onHarvest,
          onTick: onTick,
        );
}