import 'package:flame/cache.dart';
import 'package:flame/components.dart';

abstract class Plant {
  final String name;
  final int growthTime;
  final int sellPrice;
  final int incomeRate;
  final String spritePath;

  int currentAge = 0;

  Plant({
    required this.name,
    required this.growthTime,
    required this.sellPrice,
    required this.incomeRate,
    required this.spritePath,
  });

  bool get isFullyGrown => currentAge >= growthTime;

  void onHarvest() {
    // Default behavior on harvest
    print("$name harvested for $sellPrice coins");
  }

  void onTick() {
    // Increment age
    currentAge++;

    if (isFullyGrown) {
      // Generate income periodically
      print("$name generated $incomeRate coins");
    } 
  }

  Future<Sprite> loadSprite(Images images) async {
    return Sprite(images.fromCache(spritePath));
  }
}
