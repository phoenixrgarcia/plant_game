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
      {'icon': 'bag_icon.png', 'action': () => gameRef.overlays.add('inventory')},
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
