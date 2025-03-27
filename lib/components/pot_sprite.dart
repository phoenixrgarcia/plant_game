import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/components/state/pot_state.dart';
import '../plant_game.dart';

class PotSprite extends SpriteComponent with HasGameRef<PlantGame>, TapCallbacks {
  final PotState potState;  // Reference to the PotState

  PotSprite({required this.potState, required Vector2 size}) 
      : super(position: Vector2(potState.x, potState.y), size: size);

  @override
  Future<void> onLoad() async {
    // Load the initial pot sprite (this would be a generic pot image)
    sprite = await gameRef.loadSprite('sample_pot.webp');
  }

  @override
  bool onTapDown(TapDownEvent event) {
    moveCameraToPot();
    gameRef.overlays.add('inventory');
    
    return true; // Event handled
  }

  void moveCameraToPot() {
    final camera = gameRef.camera;

    // Calculate new camera position to center the pot at the top
    final newCameraPosition = Vector2(
      position.x - gameRef.size.x * .5 + size.y / 2, // Keep X position the same
      position.y - gameRef.size.y * .2 + size.y / 2, // Move Y so pot is at the top
    );

    // Move the camera smoothly
    camera.moveTo(newCameraPosition, speed: 500);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (potState.isOccupied) {
      // Draw the plant sprite on top of the pot if there's a plant
      final plantSprite = spriteFromPlantType(potState.currentFlower);
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
