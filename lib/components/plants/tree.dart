import 'plant.dart';

class Tree extends Plant {
  Tree({
    required String name,
    required int growthTime,
    required int sellPrice,
    required int incomeRate,
    required String imagePath,
    required String spritePath,
  }) : super(
          name: name,
          growthTime: growthTime,
          sellPrice: sellPrice,
          incomeRate: incomeRate,
          imagePath: imagePath,
          spritePath: spritePath,
        );
}