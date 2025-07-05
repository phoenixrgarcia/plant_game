import 'package:hive/hive.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/plants/plant_instance.dart';

part 'pot_state.g.dart';

// PotState class to store data about each pot and its logic
@HiveType(typeId: 1)
class PotState extends HiveObject {

  @HiveField(0)
  int row;  // Row index of the pot in the grid

  @HiveField(1)
  int col;  // Column index of the pot in the grid

  @HiveField(2)
  PlantInstance? currentPlant;  // The specific instance data for the plant in the pot 

  PotState({
    required this.row,
    required this.col,
    this.currentPlant,  
  });

  // Logic to plant a specific type of plant in the pot
  void plant(InventoryEntry plantEntry) {
    currentPlant = PlantInstance(plantDataName: plantEntry.plantDataName, tier: plantEntry.tier);
  }

  // Logic to remove the plant from the pot
  void removePlant() {
    currentPlant = null;
  }

  // Check if the pot is occupied
  bool get isOccupied => currentPlant != null;
}
