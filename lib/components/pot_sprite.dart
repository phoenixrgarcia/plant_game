import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/state/pot_state.dart';
import '../plant_game.dart';

class PotSprite extends SpriteComponent
    with HasGameRef<PlantGame>, TapCallbacks {
  PotState potState; // Reference to the PotState

  Sprite? plantSprite;
  String? currentSpritePath;

  //Here we are using Offset to store a fraction value for x and y coordinates.
  Map<String, Offset> targetPotPositions = {
    'top': const Offset(.5, .3),
    'bottom': const Offset(.5, .75),
  };

  PotSprite(
      {required this.potState,
      required Vector2 size,
      required Vector2 position})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load the initial pot sprite (this would be a generic pot image)
    sprite = await gameRef.loadSprite('sample_pot.webp');
  }

  @override
  bool onTapDown(TapDownEvent event) {
    gameRef.greenhouseWorld.selectPot(this);

    if (!potState.isOccupied) {
      moveCameraToPot("top");
      gameRef.overlays.add('inventory');
    } else {
      moveCameraToPot("bottom");
      gameRef.overlays.add('plant_info');
    }

    return true; // Event handled
  }

  void moveCameraToPot(String targetPosition) {
    final camera = gameRef.camera;
    final xPositionFraction = targetPotPositions[targetPosition]!.dx;
    final yPositionFraction = targetPotPositions[targetPosition]!.dy;

    // Calculate new camera position to center the pot at the top
    final newCameraPosition = Vector2(
      position.x -
          gameRef.size.x * xPositionFraction +
          size.y / 2, // Keep X position the same

      position.y -
          gameRef.size.y * yPositionFraction +
          size.y / 2, // Move Y so pot is at the top
    );

    // Move the camera smoothly
    camera.moveTo(newCameraPosition, speed: 1000);
  }

  @override
  void render(Canvas canvas) {
    if (gameRef.greenhouseWorld.selectedPot.value == this) {
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
      final plantData =
          PlantData.getById(potState.currentPlant!.plantDataName)!;

      // Check if spritePath changed (e.g. due to growth)
      if (plantData.spritePath != currentSpritePath) {
        plantSprite = Sprite(gameRef.images.fromCache(plantData.spritePath))
          ..srcPosition = Vector2(0, 0 /*gameRef.potSize.y * 50/ 2*/);
        currentSpritePath = plantData.spritePath;
      }
    } else {
      plantSprite = null;
      currentSpritePath = null;
    }
  }
}
