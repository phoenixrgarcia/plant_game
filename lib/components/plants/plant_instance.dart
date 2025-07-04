import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/plant.dart';

part 'plant_instance.g.dart';

@HiveType(typeId: 3)
class PlantInstance extends HiveObject{
  @HiveField(0)
  final String plantDataName;

  @HiveField(1)
  int currentAge;

  @HiveField(2)
  int tier;

  PlantInstance({
    required this.plantDataName, this.currentAge = 0, required this.tier,
  });

  Plant get plantData => PlantData.getById(plantDataName)!;

  bool get isFullyGrown => currentAge >= PlantData.getById(plantDataName)!.growthTime;

  void incrementAge() {
    currentAge++;
  }

}
