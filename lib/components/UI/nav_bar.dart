import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/plant_game.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flame/game.dart';

class NavBarWidget extends StatelessWidget {
  final PlantGame gameRef;

  const NavBarWidget({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'icon': 'shop_icon.png', 'action': () => gameRef.overlays.add('shop')},
      {'icon': 'bag_icon.png', 'action': () => print("Bag button pressed")},
      {'icon': 'pot_icon.png', 'action': () => gameRef.overlays.clear()},
      {'icon': 'upgrade_icon.png', 'action': () => print("Upgrade button pressed")},
      {'icon': 'settings_icon.png', 'action': () => print("Settings button pressed")},
    ];

    return Container(
      height: 60, // Adjust height as needed
      color: const Color.fromARGB(255, 151, 151, 158),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return IconButton(
            icon: Image.asset('assets/images/${button['icon']}'),
            iconSize: 40, // Adjust icon size
            onPressed: button['action'],
          );
        }).toList(),
      ),
    );
  }
}


// class NavBarComponent extends PositionComponent with HasGameRef<PlantGame> {
//   NavBarComponent({required Vector2 screenSize}) {
//     size = Vector2(screenSize.x, screenSize.y * 0.1); // 10% screen height
//     position = Vector2(0, screenSize.y - size.y); // Fixed at bottom
//   }

//   @override
//   Future<void> onLoad() async {
//     final background = RectangleComponent(
//       size: size,
//       paint: Paint()..color = const Color.fromARGB(255, 151, 151, 158),
//     );
//     add(background);

//     final icons = ['shop_icon.png', 'bag_icon.png', 'pot_icon.png', 'upgrade_icon.png', 'settings_icon.png'];
//     final buttonActions = [
//       () => gameRef.router.pushNamed('shop'),
//       () => print("Bag button pressed"),
//       () => print("Pot button pressed"),
//       () => print("Upgrade button pressed"),
//       () => print("Settings button pressed"),
//     ];

//     final buttonSize = Vector2(size.y * 0.8, size.y * 0.8);
//     final spacing = (size.x - (buttonSize.x * 5)) / 6;

//     for (int i = 0; i < 5; i++) {
//       final sprite = await gameRef.loadSprite(icons[i]);
//       final button = SpriteButtonComponent(
//         button: sprite,
//         buttonDown: sprite,
//         size: buttonSize,
//         position: Vector2(spacing + i * (buttonSize.x + spacing), (size.y - buttonSize.y) / 2),
//         onPressed: buttonActions[i],
//       );
//       add(button);
//     }
//   }
// }
