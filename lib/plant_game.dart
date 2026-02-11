import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:plant_game/components/UI/tick_timer.dart';
import 'package:plant_game/components/money_display.dart';
import 'package:plant_game/game_state_manager.dart';

import 'worlds/greenhouse_world.dart';

// This file contains the main game class. This is where the game is initialized and the camera is set up.
// The camera is used to pan around the game world.
// This file contains logic for viewing the world, while the game logic is inside greenhouse_world.dart

class PlantGame extends FlameGame with PanDetector, TapCallbacks {
  final GameStateManager gameStateManager;
  late final RouterComponent router;
  late final TickTimer tickTimer;
  late final MoneyDisplay moneyDisplay;
  late final GreenhouseWorld greenhouseWorld;
  

  final Vector2 potSize = Vector2(80, 80);
  //@override bool get debugMode => true; // Enables debug mode

  PlantGame({required this.gameStateManager}) : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Preload images into the cache
    await images.loadAll([
      'tomato.png',
      'carrot.png',
      'rose.png',
      'oak_tree.jpg',
      'giving_tree.png',
      'apple-tree.webp',
      'sprout.png',
      'ironbark_tree.png',
      'palm_tree.png',
      'pine_tree.png',
      'redwood_tree.png',
      'sakura_tree.png',
      'tulip.jpg',
      'star_particle.png',
    ]);

    final backgroundSprite = await loadSprite('blue_background.jpg');
    final backgroundComponent = SpriteComponent(
      sprite: backgroundSprite,
      size: size, // Match the world size
    );

    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
    );

    world = GreenhouseWorld(gameStateManager: gameStateManager); // Attach world to FlameGame
    greenhouseWorld = world as GreenhouseWorld;

    camera.world = world; // Attach world to camera
    camera.viewfinder.anchor = Anchor.topLeft; // Anchor camera to topLeft
    camera.backdrop = backgroundComponent; // Set background color

    // header bar, which is background for header bar components. Extract this to a component later?
    final headerBar = RectangleComponent(
      size: Vector2(size.x, size.y * 0.13),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
      paint: Paint()..color = const Color.fromARGB(255, 151, 151, 158),
    );
    camera.viewport.add(headerBar);

    overlays.add('money');
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final delta = info.delta.global;

    // Move the camera opposite to the drag direction
    final newPosition = camera.viewfinder.position - delta;

    final padding = 20;

    // Keep the camera within bounds (adjust world size as needed)
    final minX = -size.x / 2 +
            potSize.x * 2 -
            100 * potSize.x +
            padding,
        minY = -size.y / 2 + potSize.y * 2,
        maxX = size.x / 2 -
            potSize.x * 2 +
            100 * potSize.x -
            padding,
        maxY = size.y / 2 - potSize.y * 2;
    camera.viewfinder.position = Vector2(
      newPosition.x.clamp(minX, maxX),
      newPosition.y.clamp(minY, maxY),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    greenhouseWorld.deselectPot();
    overlays.remove('inventory');
    overlays.remove('plant_info');
    overlays.remove('purchase_pot_dialog');
  }

  
}
