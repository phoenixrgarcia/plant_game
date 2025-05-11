import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/state/pot_state.dart';
import '../plant_game.dart';

class PotSprite extends SpriteComponent
    with HasGameRef<PlantGame>, TapCallbacks {
  final PotState potState; // Reference to the PotState

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
    gameRef.greenhouseWorld.selectPot(this);

    // I should add logic here. If the pot is empty, I should open the inventory and allow the user to plant a seed.
    // If the pot is occupied, I should open some menu about plant info.
    gameRef.overlays.add('inventory');

    return true; // Event handled
  }

  void moveCameraToPot() {
    final camera = gameRef.camera;

    // Calculate new camera position to center the pot at the top
    final newCameraPosition = Vector2(
      position.x - gameRef.size.x * .5 + size.y / 2, // Keep X position the same
      position.y -
          gameRef.size.y * .2 +
          size.y / 2, // Move Y so pot is at the top
    );

    // Move the camera smoothly
    camera.moveTo(newCameraPosition, speed: 500);
  }

  @override
  void render(Canvas canvas) {
    if (gameRef.greenhouseWorld.selectedPot == this) {
      renderSelectedPot(canvas);
    }

    super.render(canvas);
    if (potState.isOccupied) {
      // Draw the plant sprite on top of the pot if there's a plant
      final plantSprite = spriteFromPlantType();
      plantSprite.render(canvas);
    }
  }

  // Helper function to get the appropriate plant sprite based on the type
  SpriteComponent spriteFromPlantType() {
    return SpriteComponent()
      ..sprite = Sprite(gameRef.images.fromCache(potState.currentPlant!.spritePath))
      ..position = position;
  }

  void renderSelectedPot(Canvas canvas) {
    final glowPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Adjust the rectangle to account for the anchor
    final rect = Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );

    //canvas.drawRect(rect, paint);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * .6, glowPaint);
  }
}