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
      {
        'icon': 'shop_icon.png',
        'action': () {
          if (gameRef.overlays.isActive('shop')) {
            gameRef.overlays.remove('shop'); // Close if already open
          } else {
            gameRef.overlays.add('shop'); // Open if closed
          }
        }
      },
      {
        'icon': 'bag_icon.png',
        'action': () {
          if (gameRef.overlays.isActive('inventory')) {
            gameRef.overlays.remove('inventory'); // Close if already open
          } else {
            gameRef.overlays.add('inventory'); // Open if closed
          }
        }
      },
      {
        'icon': 'pot_icon.png',
        'action': () {
          gameRef.overlays.clear();
          gameRef.overlays.add('money');
        }
      },
      {
        'icon': 'upgrade_icon.png',
        'action': () {
          gameRef.overlays.clear();
          gameRef.overlays.add('upgrade');
        }
      },
      {
        'icon': 'settings_icon.png',
        'action': () => print("Settings button pressed")
      },
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
