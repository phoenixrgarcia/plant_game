import 'plant.dart';

class Tree extends Plant {
  Tree({
    required String name,
    required int growthTime,
    required int sellPrice,
    required int incomeRate,
    required String spritePath,
  }) : super(
          name: name,
          growthTime: growthTime,
          sellPrice: sellPrice,
          incomeRate: incomeRate,
          spritePath: spritePath,
        );

  @override
  void onTick() {
    // Trees generate income periodically
  }
}