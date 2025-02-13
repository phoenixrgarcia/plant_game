import 'package:hive/hive.dart';

// PotState class to store data about each pot and its logic
@HiveType(typeId: 1)
class PotState extends HiveObject {
  @HiveField(0)
  double x;  // X position of the pot

  @HiveField(1)
  double y;  // Y position of the pot

  @HiveField(2)
  String currentFlower;  // The type of flower in the pot, 'Empty' if no plant

  PotState({
    required this.x,
    required this.y,
    this.currentFlower = 'Empty',  // Default is 'Empty'
  });

  // Logic to plant a specific type of plant in the pot
  void plant(String plant) {
    currentFlower = plant;
  }

  // Logic to remove the plant from the pot
  void removePlant() {
    currentFlower = 'Empty';
  }

  // Check if the pot is occupied
  bool get isOccupied => currentFlower != 'Empty';
}
