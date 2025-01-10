import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../plant_game.dart';

class PotLogic {
  bool isOccupied;
  String? plantType;

  PotLogic({this.isOccupied = false, this.plantType});

  // Plant a specific type of plant in the pot
  void plant(String plant) {
    isOccupied = true;
    plantType = plant;
  }

  // Remove the plant from the pot
  void removePlant() {
    isOccupied = false;
    plantType = null;
  }

  // Check if the pot is occupied
  bool get isPotOccupied => isOccupied;
}

class PotSprite extends SpriteComponent with HasGameRef<PlantGame> {
  final PotLogic potLogic;

  PotSprite({required Vector2 position, required Vector2 size})
      : potLogic = PotLogic(),
        super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load the initial pot sprite (this would be a generic pot image)
    sprite = await gameRef.loadSprite('sample_pot.webp');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (potLogic.isPotOccupied && potLogic.plantType != null) {
      // Draw the plant sprite on top of the pot if there's a plant
      final plantSprite = spriteFromPlantType(potLogic.plantType!);
      plantSprite.render(canvas);
    }
  }

  // Helper function to get the appropriate plant sprite based on the type
  SpriteComponent spriteFromPlantType(String plantType) {
    // Assuming you have different sprites for different plant types
    switch (plantType) {
      case 'Flower':
        return SpriteComponent()
          ..sprite = Sprite(gameRef.images.fromCache('flower.png'))
          ..position = position; // Position it correctly above the pot
      case 'Tree':
        return SpriteComponent()
          ..sprite = Sprite(gameRef.images.fromCache('tree.png'))
          ..position = position;
      default:
        return SpriteComponent(); // Return an empty component for unrecognized types
    }
  }
}
