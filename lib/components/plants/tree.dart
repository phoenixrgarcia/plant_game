import 'plant.dart';

class Tree extends Plant {
  Tree({
    required String name,
    required double growthTime,
    required double sellPrice,
    required double incomeRate,
    required int rarity,
    required String imagePath,
    required String spritePath,
  }) : super(
          name: name,
          growthTime: growthTime,
          sellPrice: sellPrice,
          incomeRate: incomeRate,
          rarity: rarity,
          imagePath: imagePath,
          spritePath: spritePath,
        );
}