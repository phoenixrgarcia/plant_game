import '../crop.dart';
import '../plant.dart';

class PlantData{
  static final Map<String, Crop> _crops = {
    'tomato': Crop(
      name: 'Tomato',
      growthTime: 10,
      sellPrice: 15,
      incomeRate: 2,
      imagePath: 'assets/images/tomato.png',
      spritePath: 'tomato.png',
      // onHarvest: () => print('Tomato harvested!'),
      // onTick: () => print('Tomato ticked!'),
    ),
    'carrot': Crop(
      name: 'Carrot',
      growthTime: 15,
      sellPrice: 20,
      incomeRate: 3,
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

  static List<Plant> get all => _crops.values.toList();
}
