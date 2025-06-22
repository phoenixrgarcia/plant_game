import 'plant.dart';

class Crop extends Plant {
  Crop({
    required String name,
    required int growthTime,
    required int sellPrice,
    required int incomeRate,
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