import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:plant_game/components/UI/tick_timer.dart';
import 'package:plant_game/components/money_display.dart';

import 'worlds/greenhouse_world.dart';

// This file contains the main game class. This is where the game is initialized and the camera is set up.
// The camera is used to pan around the game world.
// This file contains logic for viewing the world, while the game logic is inside greenhouse_world.dart

class PlantGame extends FlameGame with PanDetector {
  late final RouterComponent router;
  late final TickTimer tickTimer;
  late final MoneyDisplay moneyDisplay;
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

    // header bar, which is background for header bar components. Extract this to a component later?
    final headerBar = RectangleComponent(
      size: Vector2(size.x, size.y * 0.13),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
      paint: Paint()..color = const Color.fromARGB(255, 151, 151, 158),
    );
    camera.viewport.add(headerBar);

    // tick timer that represents when ticks happen
    // part of header bar
    // TODO make this size depend on header bar
    tickTimer = TickTimer(tickRate: 5.0)
      ..size = Vector2(size.x * 0.3, size.y * 0.05)
      ..position = Vector2(size.x * 0.05, size.y * 0.09)
      ..anchor = Anchor.centerLeft
      ..priority = 100;
    camera.viewport.add(tickTimer); 

    // tick timer that represents money the player has
    // part of header bar
    moneyDisplay = MoneyDisplay()
      ..position = Vector2(size.x * 0.90, size.y * 0.09)
      ..anchor = Anchor.centerRight
      ..priority = 100;
    camera.viewport.add(moneyDisplay); 
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final delta = info.delta.global;

    // Move the camera opposite to the drag direction
    final newPosition = camera.viewfinder.position - delta;

    // Keep the camera within bounds (adjust world size as needed)
    final minX = -100.0, minY = -100.0, maxX = 100.0, maxY = 100.0;
    camera.viewfinder.position = Vector2(
      newPosition.x.clamp(minX, maxX),
      newPosition.y.clamp(minY, maxY),
    );
  }
}
