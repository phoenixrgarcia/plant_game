import 'plant.dart';

class Crop extends Plant {
  Crop({
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
  void onHarvest() {
    super.onHarvest();
    // Maybe crops regrow or give seeds?
  }
}