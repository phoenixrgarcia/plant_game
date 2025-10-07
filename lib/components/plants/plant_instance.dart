import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/plant.dart';
import 'package:plant_game/components/state/pot_state.dart';

part 'plant_instance.g.dart';

@HiveType(typeId: 3)
class PlantInstance extends HiveObject{
  @HiveField(0)
  final String plantDataName;

  @HiveField(1)
  double currentAge;

  @HiveField(2)
  int tier;

  @HiveField(3)
  double addBonus;

  @HiveField(4)
  double multBonus;

  @HiveField(5)
  double flatBonus;

  PlantInstance({
    required this.plantDataName, this.currentAge = 0, required this.tier, this.addBonus = 0, this.multBonus = 0, this.flatBonus = 0
  });

  Plant get plantData => PlantData.getById(plantDataName)!;

  bool get isFullyGrown => currentAge >= PlantData.getById(plantDataName)!.growthTime;

  void incrementAge() {
    currentAge += 1;
  }

  void mutateMultValues(List<List<double>> multValues, List<List<PotState>> potStates) {
    final plantData = PlantData.getById(plantDataName);
    if (plantData != null) {
      // TODO, extend plant class to have a mutateMultValues method
      //plantData.mutateMultValues(multValues, potStates, tier);
    }
  }

}
