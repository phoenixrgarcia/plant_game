import '../crop.dart';
import '../plant.dart';
import 'dart:math';

class PlantData{
  static final Map<String, Crop> _crops = {
    'tomato': Crop(
      name: 'Tomato',
      growthTime: 10,
      sellPrice: 15,
      incomeRate: 2,
      rarity: 50,
      imagePath: 'assets/images/tomato.png',
      spritePath: 'tomato.png',
      // onHarvest: () => print('Tomato harvested!'),
      // onTick: () => print('Tomato ticked!'),
      description: 'A juicy red fruit, perfect for salads and sauces.',
      specialProperties: "Does nothing special",
    ),
    'carrot': Crop(
      name: 'Carrot',
      growthTime: 15,
      sellPrice: 25,
      incomeRate: 3,
      rarity: 20,
      imagePath: 'assets/images/carrot.png',
      spritePath: 'carrot.png',
      // onHarvest: () => print('Carrot harvested!'),
      // onTick: () => print('Carrot ticked!'),
    ),
  };

  static Plant? getById(String id) => _crops[id];

  static void register(String id, Crop plant) {
    _crops[id] = plant;
  }

  static Plant getWeightedRandom() {
    // Implement weighted random selection based on rarity
    final random = Random();
    int totalRarity = _crops.values.fold(0, (sum, crop) => sum + crop.rarity);
    int randomValue = (totalRarity * random.nextDouble()).toInt(); // Example: 50% chance
    for (var crop in _crops.values) {
      if (randomValue < crop.rarity) {
        return crop;
      }
      randomValue -= crop.rarity;
    }
    return _crops.values.first; // Fallback
  }

  static List<Plant> get allCrops => _crops.values.toList();

}
