import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/plant_game.dart';

import '../components/pot_component.dart';

class GreenhouseScreen extends Component with HasGameRef<PlantGame> {
  //late SpriteComponent background;
  late final List<List<PotSprite>> gardenPots = [];
  late final iconList;

  @override
  Future<void> onLoad() async {
    // Create and position the background as a light grey rectangle
    final background = RectangleComponent(
      size: gameRef.size, // Match the screen size
      paint: Paint()
        ..color = const Color.fromARGB(255, 83, 88, 126), // Light grey color
    );

    final shopIcon = await gameRef.loadSprite('shop_icon.png');
    final bagIcon = await gameRef.loadSprite('bag_icon.png');
    final potIcon = await gameRef.loadSprite('pot_icon.png');
    final upgradeIcon = await gameRef.loadSprite('upgrade_icon.png');
    final settingsIcon = await gameRef.loadSprite('settings_icon.png');
    iconList = [shopIcon, bagIcon, potIcon, upgradeIcon, settingsIcon];

    // Add the background to the screen
    add(background);

    // Optionally, add placeholders for garden pots
    addInitialGardenSpots();
    addNavigationBar();
  }

  void addInitialGardenSpots() {
    final Vector2 screenSize = gameRef.size;

    gardenPots.add([]);
    const int rows = 1;
    const int cols = 3;

    // Calculate pot size (1/3 of 80% of the screen width)
    final double potSize = (screenSize.x * 0.65) / cols;

    // Calculate spacing to center the pots
    final double spacing = (screenSize.x - (cols * potSize)) / (cols + 1);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Calculate position
        final double x = col * (potSize + spacing) + spacing;
        final double y =
            (screenSize.y * 0.5) - (potSize / 2); // Vertically centered

        // Create a PotComponent
        final pot = PotSprite(
          position: Vector2(x, y),
          size: Vector2(potSize, potSize),
        );

        // Add to the game and the list
        add(pot);
        gardenPots[0].add(pot);
      }
    }
  }

  Future<void> addNavigationBar() async {
    final screenSize = gameRef.size;
    final double navBarHeight = screenSize.y * 0.1; // 10% of screen height

    // Create the background bar
    final navBar = RectangleComponent(
      size: Vector2(screenSize.x, navBarHeight),
      position: Vector2(0, screenSize.y - navBarHeight),
      paint: Paint()
        ..color = const Color.fromARGB(255, 151, 151, 158), // Dark grey color
    );

    // Add buttons or icons as children
    final buttonSize = Vector2(navBarHeight * 0.8,
        navBarHeight * 0.8); // Slightly smaller than bar height
    final double spacing = (screenSize.x - (buttonSize.x * 5)) / 6;

    for (int i = 0; i < 5; i++) {
      final button = SpriteButtonComponent(
        button: iconList[i], // Button image
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

    add(navBar);
  }
}
