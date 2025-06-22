import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/state/pot_state.dart';
import '../plant_game.dart';

class PotSprite extends SpriteComponent
    with HasGameRef<PlantGame>, TapCallbacks {
  final PotState potState; // Reference to the PotState

  Sprite? plantSprite;
  String? currentSpritePath;

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
    
    if (plantSprite != null) {
      plantSprite!.render(canvas, size: size);
    }
  }

  void renderSelectedPot(Canvas canvas) {
    final glowPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    //canvas.drawRect(rect, paint);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * .6, glowPaint);
  }

  Future<void> updatePlantSprite() async {
    if (potState.isOccupied) {
      final plantData = PlantData.getById(potState.currentPlant!.plantDataName)!;

      // Check if spritePath changed (e.g. due to growth)
      if (plantData.spritePath != currentSpritePath) {
        plantSprite = Sprite(gameRef.images.fromCache(plantData.spritePath));
        currentSpritePath = plantData.spritePath;
      }
    } else {
      plantSprite = null;
      currentSpritePath = null;
    }
  }
}