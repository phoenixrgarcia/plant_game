import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/src/components/core/component.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:plant_game/components/UI/tick_timer.dart';
import 'package:plant_game/screens/shop_screen.dart';

import 'worlds/greenhouse_world.dart';
import 'components/UI/game_ui.dart';

class PlantGame extends FlameGame with PanDetector {
  late final RouterComponent router;
  late final TickTimer tickTimer;
  //@override bool get debugMode => true; // Enables debug mode

  PlantGame() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final backgroundSprite = await loadSprite('blue_background.jpg');
    final backgroundComponent = SpriteComponent(
      sprite: backgroundSprite,
      size: size, // Match the world size
    );

    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
    );

    world = GreenhouseWorld(); // Attach world to FlameGame

    camera.world = world; // Attach world to camera
    camera.viewfinder.anchor = Anchor.topLeft; // Anchor camera to center
    camera.backdrop = backgroundComponent; // Set background color

    tickTimer = TickTimer(tickRate: 5.0)
      ..size = Vector2(size.x * 0.3, size.y * 0.05)
      ..position = Vector2(size.x * 0.05, size.y * 0.05)
      ..priority = 100;

    camera.viewport.add(tickTimer); 
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final delta = info.delta.global;

    // Move the camera opposite to the drag direction
    final newPosition = this.camera.viewfinder.position - delta;

    // Keep the camera within bounds (adjust world size as needed)
    final minX = -100.0, minY = -100.0, maxX = 100.0, maxY = 100.0;
    camera.viewfinder.position = Vector2(
      newPosition.x.clamp(minX, maxX),
      newPosition.y.clamp(minY, maxY),
    );
  }
}
