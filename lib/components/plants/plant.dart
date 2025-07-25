import 'package:flame/cache.dart';
import 'package:flame/components.dart';

abstract class Plant {
  final String name;
  final int growthTime;
  final int sellPrice;
  final int incomeRate;
  final int rarity;
  final String imagePath;
  final String spritePath;
  final String? description;
  final String? specialProperties;

  Plant({
    required this.name,
    required this.growthTime,
    required this.sellPrice,
    required this.incomeRate,
    required this.rarity,
    required this.imagePath,
    required this.spritePath,
    this.description,
    this.specialProperties,
  });

  void onHarvest() {
    print("$name harvested for $sellPrice coins");
  }

  void onTick() {
    // Increment age
    //currentAge++;
      // Generate income periodically
      print("$name generated $incomeRate coins");
    } 

  Future<Sprite> loadSprite(Images images) async {
    return Sprite(images.fromCache(spritePath));
  }
}
