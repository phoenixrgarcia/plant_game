import 'plant.dart';

class Crop extends Plant {
  Crop({
    required String name,
    required double growthTime,
    required double sellPrice,
    required double incomeRate,
    required int rarity,
    required String imagePath,
    required String spritePath,
    String? description,
    String? specialProperties,
  }) : super(
          name: name,
          growthTime: growthTime,
          sellPrice: sellPrice,
          incomeRate: incomeRate,
          rarity: rarity,
          imagePath: imagePath,
          spritePath: spritePath,
          description: description,
          specialProperties: specialProperties,
        );
}