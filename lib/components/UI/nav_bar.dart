import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/plant_game.dart';

class NavBarComponent extends PositionComponent with HasGameRef<PlantGame> {
  NavBarComponent({required Vector2 screenSize}) {
    size = Vector2(screenSize.x, screenSize.y * 0.1); // 10% screen height
    position = Vector2(0, screenSize.y - size.y); // Fixed at bottom
  }

  @override
  Future<void> onLoad() async {
    final background = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color.fromARGB(255, 151, 151, 158),
    );
    add(background);

    final icons = ['shop_icon.png', 'bag_icon.png', 'pot_icon.png', 'upgrade_icon.png', 'settings_icon.png'];
    final buttonSize = Vector2(size.y * 0.8, size.y * 0.8);
    final spacing = (size.x - (buttonSize.x * 5)) / 6;

    for (int i = 0; i < 5; i++) {
      final sprite = await gameRef.loadSprite(icons[i]);
      final button = SpriteButtonComponent(
        button: sprite,
        buttonDown: sprite,
        size: buttonSize,
        position: Vector2(spacing + i * (buttonSize.x + spacing), (size.y - buttonSize.y) / 2),
        onPressed: () => print("Button $i pressed"),
      );
      add(button);
    }
  }
}
