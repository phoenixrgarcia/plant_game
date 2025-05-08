import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:plant_game/components/plants/plant.dart';

abstract class PlantInstance {
  final Plant plantData;
  int currentAge = 0;

  PlantInstance({
    required this.plantData,
  });

  bool get isFullyGrown => currentAge >= plantData.growthTime;

  void onHarvest() {
    plantData.onHarvest?.call();
    print("$plantData.name harvested for $plantData.sellPrice coins");
  }

  void onTick() {
    // Increment age
    currentAge++;

    plantData.onTick?.call();

    if (isFullyGrown) {
      // Generate income periodically
      print("$plantData.name generated $plantData.incomeRate coins");
    } 
  }

  Future<Sprite> loadSprite(Images images) async {
    return Sprite(images.fromCache(plantData.spritePath));
  }
}
