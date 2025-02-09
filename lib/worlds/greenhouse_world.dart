import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/plant_game.dart';

import '../components/pot_component.dart';

class GreenhouseWorld extends World 
    with HasGameRef<PlantGame>, DragCallbacks {
  late final List<List<PotSprite>> gardenPots = [];
  late final iconList;
  late World world;
  final double minVisiblePots = 1; // Ensures at least one pot is visible

  @override
  Future<void> onLoad() async {
    // Setup background
    final background = RectangleComponent(
      size: gameRef.size, 
      paint: Paint()..color = const Color.fromARGB(255, 83, 88, 126),
      anchor: Anchor.center
    );
    add(background);

    // Load icons for the navigation bar
    final shopIcon = await gameRef.loadSprite('shop_icon.png');
    final bagIcon = await gameRef.loadSprite('bag_icon.png');
    final potIcon = await gameRef.loadSprite('pot_icon.png');
    final upgradeIcon = await gameRef.loadSprite('upgrade_icon.png');
    final settingsIcon = await gameRef.loadSprite('settings_icon.png');
    iconList = [shopIcon, bagIcon, potIcon, upgradeIcon, settingsIcon];

    // Add garden pots
    addInitialGardenSpots();

    // Add navigation bar (this remains fixed)
    addNavigationBar();
  }

  void addInitialGardenSpots() {
    final Vector2 screenSize = gameRef.size;
    const int rows = 1;
    const int cols = 3;

    // Pot size based on screen width
    final double potSize = (screenSize.x * 0.65) / cols;
    final double spacing = (screenSize.x - (cols * potSize)) / (cols + 1);

    gardenPots.add([]);

    for (int col = 0; col < cols; col++) {
      final double x = col * (potSize + spacing) + spacing;
      final double y = (screenSize.y * 0.5) - (potSize / 2);

      final pot = PotSprite(
        position: Vector2(x, y),
        size: Vector2(potSize, potSize),
      );

      add(pot);
      gardenPots[0].add(pot);
    }
  }

  Future<void> addNavigationBar() async {
    final screenSize = gameRef.size;
    final double navBarHeight = screenSize.y * 0.1;

    final navBar = RectangleComponent(
      size: Vector2(screenSize.x, navBarHeight),
      position: Vector2(0, screenSize.y - navBarHeight),
      paint: Paint()..color = const Color.fromARGB(255, 151, 151, 158),
    );

    final buttonSize = Vector2(navBarHeight * 0.8, navBarHeight * 0.8);
    final double spacing = (screenSize.x - (buttonSize.x * 5)) / 6;

    for (int i = 0; i < 5; i++) {
      final button = SpriteButtonComponent(
        button: iconList[i],
        buttonDown: iconList[i],
        size: buttonSize,
        position: Vector2(spacing + i * (buttonSize.x + spacing), 
          (navBarHeight - buttonSize.y) / 2),
        onPressed: () {
          print("Button $i pressed");
        },
      );
      navBar.add(button);
    }

    add(navBar); // Navigation bar should remain fixed
  }
}
