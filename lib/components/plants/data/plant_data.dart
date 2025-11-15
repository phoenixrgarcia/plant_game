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
      onTick: (pot, gsm) =>
          print('Tomato in pot at (${pot.row}, ${pot.col}) ticked!'),
      persistentEffect: (pot, gsm) =>
          print('Tomato in pot at (${pot.row}, ${pot.col}) grew!'),
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
    'Tupil': Plant(
      name: 'Tulip',
      type: 'Flower',
      growthTime: 10,
      sellPrice: 20,
      incomeRate: 1,
      tickRate: 1,
      rarity: 30,
      imagePath: 'assets/images/tulip.jpg',
      spritePath: 'tulip.jpg',
      onHarvest: () => print('Tulip harvested!'),
      onTick: (pot, gsm) => print('Tulip ticked!'),
      persistentEffect: (pot, gsm) => print('Tulip grew!'),
    ),

    //Trees
    //Legendary Trees
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
          if (neighboringPot.currentPlant == null) continue;
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
      persistentEffectAOE: 'none',
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
      persistentEffect: (otherPot, gsm) {
        print('Apple Tree grew!');
        // Increases exponential income bonus of adjacent plants (fruits get a bigger bonus)
        if (otherPot.currentPlant!.plantData.type == "Fruit") {
          otherPot.currentPlant!.exponentialBonus += 0.4;
        } else {
          otherPot.currentPlant!.exponentialBonus += 0.2;
        }
      },
      description:
          'A blossoming tree that inspires surrounding fruits to grow sweeter',
      specialProperties:
          "Exponentially increases income of adjacent plants (bonus for fruits)",
      persistentEffectAOE: 'adjacent',
      cleanUp: (selfPot, gsm) {
        print('Apple Tree removed!');
        for (var dir in PlantAoeMap['adjacent']!) {
          var newRow = selfPot.row + dir[0];
          var newCol = selfPot.col + dir[1];
          var neighboringPot = gsm.getPot(newRow, newCol);
          if (neighboringPot == null) continue;
          if (neighboringPot.currentPlant == null) continue;
          if (!neighboringPot.currentPlant!.isFullyGrown) continue;
          // Revert the exponential bonus when the plant is removed
          if (neighboringPot.currentPlant!.plantData.type == "Fruit") {
            neighboringPot.currentPlant!.exponentialBonus -= 0.4;
          } else {
            neighboringPot.currentPlant!.exponentialBonus -= 0.2;
          }
        }
      },
    ),

    //Epic Trees
    'Sakura Tree': Plant(
      name: 'Sakura Tree',
      type: 'Tree',
      growthTime: 32,
      sellPrice: 300,
      incomeRate: 30,
      tickRate: 15,
      rarity: 20,
      imagePath: 'assets/images/sakura_tree.png',
      spritePath: 'sakura_tree.png',
      onHarvest: () => print('Sakura Tree harvested!'),
      onTick: (pot, gsm) {
        print('Sakura Tree ticked!');
        // Procs the tick effect of cardinally adjacent plants every 16 ticks
        if (pot.currentPlant!.currentAge % 16 == 0) {
          for (var dir in PlantAoeMap['cardinal']!) {
            var newRow = pot.row + dir[0];
            var newCol = pot.col + dir[1];
            var neighboringPot = gsm.getPot(newRow, newCol);
            if (neighboringPot == null) continue;
            if (neighboringPot.currentPlant == null) continue;
            neighboringPot.currentPlant!.plantData.onTick(neighboringPot, gsm);
          }
        }
      },
      description: 'A beautiful cherry blossom tree that enchants the garden.',
      specialProperties:
          "Procs the tick effect of cardinally adjacent plants every 16 ticks",
      persistentEffectAOE: 'cardinal',
    ),

    'Redwood Tree': Plant(
      name: 'Redwood Tree',
      type: 'Tree',
      growthTime: 60,
      sellPrice: 800,
      incomeRate: 600,
      tickRate: 60,
      rarity: 20,
      imagePath: 'assets/images/redwood_tree.png',
      spritePath: 'redwood_tree.png',
      onHarvest: () => print('Redwood Tree harvested!'),
      onTick: (pot, gsm) => print('Redwood Tree ticked!'),
      description:
          'A towering tree that stands as a testament to time and nature.',
      specialProperties: "Slowly generates massive income",
      persistentEffectAOE: 'none',
    ),

    'Ironbark Tree': Plant(
      name: 'Ironbark Tree',
      type: 'Tree',
      growthTime: 30,
      sellPrice: 400,
      incomeRate: 20,
      tickRate: 20,
      rarity: 20,
      imagePath: 'assets/images/ironbark_tree.png',
      spritePath: 'ironbark_tree.png',
      onHarvest: () => print('Ironbark Tree harvested!'),
      onTick: (pot, gsm) => print('Ironbark Tree ticked!'),
      description:
          'A sturdy tree with bark as hard as iron, protecting its garden.',
      specialProperties:
          "Gives a 2x mult to adjacent plants, but reduces tickrate by 8s",
      persistentEffect: (otherPot, gsm) {
        print('Ironbark Tree grew!');
        // Increases income multiplier of adjacent plants but slows their tickrate
        otherPot.currentPlant!.multBonus += 2.0;
        otherPot.currentPlant!.tickRateFlat += 8;
      },
      persistentEffectAOE: 'square',
      cleanUp: (selfPot, gsm) {
        print('Ironbark Tree removed!');
        for (var dir in PlantAoeMap['square']!) {
          var newRow = selfPot.row + dir[0];
          var newCol = selfPot.col + dir[1];
          var neighboringPot = gsm.getPot(newRow, newCol);
          if (neighboringPot == null) continue;
          if (neighboringPot.currentPlant == null) continue;
          if (!neighboringPot.currentPlant!.isFullyGrown) continue;
          // Revert the bonuses when the plant is removed
          neighboringPot.currentPlant!.multBonus -= 2.0;
          neighboringPot.currentPlant!.tickRateFlat -= 8;
        }
      },
    ),

    //Rare Trees
    'Pine Tree': Plant(
      name: 'Pine Tree',
      type: 'Tree',
      growthTime: 15,
      sellPrice: 120,
      incomeRate: 10,
      tickRate: 10,
      rarity: 40,
      imagePath: 'assets/images/pine_tree.png',
      spritePath: 'pine_tree.png',
      onHarvest: () => print('Pine Tree harvested!'),
      onTick: (pot, gsm) => print('Pine Tree ticked!'),
      description: 'A tall tree whos cones support other plants.',
      specialProperties:
          "Gives a 15 flat income boost to the two plants above it",
      persistentEffect: (otherPlant, gameStateManager) {
        print('Pine Tree grew!');
        if (otherPlant.currentPlant == null) return;
        otherPlant.currentPlant!.addBonus += 15;
      },
      persistentEffectAOE: 'up2',
      cleanUp: (self, gameStateManager) {
        print('Pine Tree removed!');
        for (var dir in PlantAoeMap['up2']!) {
          var newRow = self.row + dir[0];
          var newCol = self.col + dir[1];
          var neighboringPot = gameStateManager.getPot(newRow, newCol);
          if (neighboringPot == null) continue;
          if (neighboringPot.currentPlant == null) continue;
          if (!neighboringPot.currentPlant!.isFullyGrown) continue;
          // Revert the add bonus when the plant is removed
          neighboringPot.currentPlant!.addBonus -= 15;
        }
      },
    ),

    'Palm Tree': Plant(
      name: 'Palm Tree',
      type: 'Tree',
      growthTime: 12,
      sellPrice: 100,
      incomeRate: 8,
      tickRate: 8,
      rarity: 40,
      imagePath: 'assets/images/palm_tree.png',
      spritePath: 'palm_tree.png',
      onHarvest: () => print('Palm Tree harvested!'),
      onTick: (pot, gsm) => print('Palm Tree ticked!'),
      description: 'A tropical tree that brings a relaxing vibe to the garden.',
      specialProperties: "Makes plants diagonally adjacent tick 1.2x faster",
      persistentEffect: (otherPot, gsm) {
        print('Palm Tree grew!');
        otherPot.currentPlant!.tickRateMult += 0.2;
      },
      persistentEffectAOE: 'diagonal',
      cleanUp: (selfPot, gsm) {
        print('Palm Tree removed!');
        for (var dir in PlantAoeMap['diagonal']!) {
          var newRow = selfPot.row + dir[0];
          var newCol = selfPot.col + dir[1];
          var neighboringPot = gsm.getPot(newRow, newCol);
          if (neighboringPot == null) continue;
          if (neighboringPot.currentPlant == null) continue;
          if (!neighboringPot.currentPlant!.isFullyGrown) continue;
          // Revert the tick rate multiplier when the plant is removed
          neighboringPot.currentPlant!.tickRateMult -= 0.2;
        }
      },
    ),

    'Oak Tree': Plant(
      name: 'Oak Tree',
      type: 'Tree',
      growthTime: 30,
      sellPrice: 150,
      incomeRate: 20,
      tickRate: 12,
      rarity: 40,
      imagePath: 'assets/images/oak_tree.jpg',
      spritePath: 'oak_tree.jpg',
      onHarvest: () => print('Oak Tree harvested!'),
      onTick: (self, gsm) {
        print('Oak Tree ticked!');
        if((self.currentPlant!.currentAge - 30) % 64  == 0){
          // earns 100x value every 64 ticks
          gsm.mutateMoney(self.currentPlant!.plantData.incomeRate * 100);
        }
      },
      description: 'A sturdy tree that symbolizes strength and endurance.',
      specialProperties: "Earns 100x income every 64 ticks after fully grown",
      persistentEffectAOE: 'none',
    ), 
  };

  static final Set<String> plantTypes = _plants.values.map((plant) => plant.type).toSet(); 

  static Plant? getById(String id) => _plants[id];

  //not planned to be used, might get removed
  static void register(String id, Plant plant) {
    _plants[id] = plant;
  }

  static String getWeightedRandom(int seed, {String? plantType}) {
    // Implement weighted random selection based on rarity
    final random = Random(seed);
    var plantList = _plants.values.toList();
    if (plantType != null) {
      plantList = plantList.where((plant) => plant.type == plantType).toList();
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
