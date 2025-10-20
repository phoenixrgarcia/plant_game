import 'dart:ffi';

import '../plant.dart';
import 'dart:math';
import 'package:plant_game/components/plants/plant_aoe_map.dart';

class PlantData {
  static final Map<String, Plant> _plants = {
    //Debug crops
    'Tomato': Plant(
      name: 'Tomato',
      type: 'Crop',
      growthTime: 3,
      sellPrice: 15,
      incomeRate: 2,
      tickRate: 2,
      rarity: 50,
      imagePath: 'assets/images/tomato.png',
      spritePath: 'tomato.png',
      onHarvest: () => print('Tomato harvested!'),
      onTick: (pot, gsm) => print('Tomato in pot at (${pot.row}, ${pot.col}) ticked!'),
      persistentEffect: (pot, gsm) => print('Tomato in pot at (${pot.row}, ${pot.col}) grew!'),
      description: 'A juicy red fruit, perfect for salads and sauces.',
      specialProperties: "Does nothing special",
    ),
    'Carrot': Plant(
      name: 'Carrot',
      type: 'Crop',
      growthTime: 15,
      sellPrice: 25,
      incomeRate: 3,
      tickRate: 1,
      rarity: 20,
      imagePath: 'assets/images/carrot.png',
      spritePath: 'carrot.png',
      onHarvest: () => print('Carrot harvested!'),
      onTick: (pot, gsm) => print('Carrot ticked!'),
      persistentEffect: (pot, gsm) => print('Carrot grew!'),
    ),

    //Trees
    'Giving Tree': Plant(
      name: 'Giving Tree',
      type: 'Tree',
      growthTime: 60,
      sellPrice: 200,
      incomeRate: 20,
      tickRate: 30,
      rarity: 5,
      imagePath: 'assets/images/giving_tree.png',
      spritePath: 'giving_tree.png',
      onHarvest: () => print('Giving Tree harvested!'),
      onTick: (self, gsm) {
        // Gives a flat income boost to cardinally adjacent plants

        for (var dir in PlantAoeMap['cardinal']!) {
          var newRow = self.row + dir[0];
          var newCol = self.col + dir[1];
          var neighboringPot = gsm.getPot(newRow, newCol);
          if (neighboringPot == null) continue;
          if (!neighboringPot.currentPlant!.isFullyGrown) continue;
          neighboringPot.currentPlant?.flatBonus += 0.1;
        }
        
        gsm.save();
        gsm.notify();
      },
      persistentEffect: (pot, gsm) => print('Apple Tree grew!'),
      description:
          'A mystical tree that generously gives to the plants around it',
      specialProperties:
          "Adds small income boost to cardinally adjacent plants",
      plantAOE: 'cardinal',
    ),
    'Apple Tree': Plant(
      name: 'Apple Tree',
      type: 'Tree',
      growthTime: 5,
      sellPrice: 190,
      incomeRate: 25,
      tickRate: 20,
      rarity: 5,
      imagePath: 'assets/images/apple-tree.webp',
      spritePath: 'apple-tree.webp',
      onHarvest: () => print('Apple Tree harvested!'),
      onTick: (pot, gsm) => print('Apple Tree ticked!'),
      persistentEffect: (pot, gsm) {
        print('Apple Tree grew!');
        // Increases exponential income bonus of adjacent plants (fruits get a bigger bonus)

        gsm.updateExponentialBonus(pot.row, pot.col, .2);
        print("Updated exponential bonus at ($pot.row, $pot.col)");
        if (pot.currentPlant!.plantData.type == "Fruit") {
          pot.currentPlant!.exponentialBonus += 0.3;
        } 
      },
      description:
          'A blossoming tree that inspires surrounding fruits to grow sweeter',
      specialProperties:
          "Exponentially increases income of adjacent plants (bonus for fruits)",
      plantAOE: 'adjacent',
    ),
    'Sakura Tree': Plant(
      name: 'Sakura Tree',
      type: 'Tree',
      growthTime: 10,
      sellPrice: 300,
      incomeRate: 30,
      tickRate: 15,
      rarity: 30,
      imagePath: 'assets/images/sakura_tree.png',
      spritePath: 'sakura_tree.png',
      onHarvest: () => print('Sakura Tree harvested!'),
      onTick: (pot, gsm) => print('Sakura Tree ticked!'),
      description: 'A beautiful cherry blossom tree that enchants the garden.',
      specialProperties: "Procs the tick effect of cardinally adjacent plants",
      plantAOE: 'cardinal',
    ),
  };

  static Plant? getById(String id) => _plants[id];

  //not planned to be used, might get removed
  static void register(String id, Plant plant) {
    _plants[id] = plant;
  }

  static String getWeightedRandom(int seed, {String? classType}) {
    // Implement weighted random selection based on rarity
    final random = Random(seed);
    var plantList = _plants.values.toList();
    if (classType != null) {
      plantList = plantList.where((plant) => plant.type == classType).toList();
      if (plantList.isEmpty) {
        plantList =
            _plants.values.toList(); // Fallback to all plants if none match
      }
    }
    int totalRarity = plantList.fold(0, (sum, plant) => sum + plant.rarity);
    int randomValue = random.nextInt(totalRarity);
    for (var plant in plantList) {
      if (randomValue < plant.rarity) {
        return plant.name;
      }
      randomValue -= plant.rarity;
    }
    return _plants.values.first.name; // Fallback
  }

  static List<Plant> get allPlants => _plants.values.toList();
}
