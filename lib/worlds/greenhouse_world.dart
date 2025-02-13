import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/plant_game.dart';

import '../components/pot_component.dart';

class GreenhouseWorld extends World 
    with HasGameRef<PlantGame> {
  late final List<List<PotSprite>> gardenPots = [];
  late final iconList;
  late World world;
  final double minVisiblePots = 1; // Ensures at least one pot is visible

  @override
  Future<void> onLoad() async {
    // // Setup background
    // final background = RectangleComponent(
    //   size: gameRef.size, 
    //   paint: Paint()..color = const Color.fromARGB(255, 83, 88, 126),
    //   priority: -10, // Behind everything
    // );
    // add(background);

    // Load icons for the navigation bar
    final shopIcon = await gameRef.loadSprite('shop_icon.png');
    final bagIcon = await gameRef.loadSprite('bag_icon.png');
    final potIcon = await gameRef.loadSprite('pot_icon.png');
    final upgradeIcon = await gameRef.loadSprite('upgrade_icon.png');
    final settingsIcon = await gameRef.loadSprite('settings_icon.png');
    iconList = [shopIcon, bagIcon, potIcon, upgradeIcon, settingsIcon];

    // Add garden pots
    addInitialGardenSpots();
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
}
