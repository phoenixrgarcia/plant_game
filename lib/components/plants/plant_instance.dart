import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/plant.dart';
import 'package:plant_game/components/state/pot_state.dart';

part 'plant_instance.g.dart';

@HiveType(typeId: 3)
class PlantInstance extends HiveObject {
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

  @HiveField(6)
  double exponentialBonus;

  //This field is ADDED to the tick rate of the plant, and can be positive or negative
  @HiveField(7)
  double tickRateFlat;

  //This field is MULTIPLIED to the tick rate of the plant, and can be positive or negative (e.g. 0.2 would make the tick rate 20% faster, -0.2 would make it 20% slower)
  @HiveField(8)
  double tickRateMult;

  @HiveField(9)
  double tickProgress;

  @HiveField(10)
  bool isFullyGrown;

  PlantInstance({
    required this.plantDataName,
    this.currentAge = 0,
    required this.tier,
    this.addBonus = 0,
    this.multBonus = 0,
    this.flatBonus = 0,
    this.exponentialBonus = 0,
    this.tickRateFlat = 0,
    this.tickRateMult = 1,
    this.tickProgress = 0,
    this.isFullyGrown = false,
  });

  Plant get plantData => PlantData.getById(plantDataName)!;


  void incrementAge() {
    currentAge += 1;
  }
}
