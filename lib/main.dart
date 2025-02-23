import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_game/components/UI/nav_bar.dart';
import 'package:plant_game/components/UI/game_ui.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/screens/inventory_screen.dart';
import 'plant_game.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/shop_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
  await Hive.initFlutter();

  await GameStateManager.init(); // Initialize the manager and open the box

  final game = PlantGame();

  runApp(
    MaterialApp(
      home: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'shop': (_, __) => const ShopScreen(),
              'inventory': (_, __) => InventoryScreen(
                    onClose: () => game.overlays.remove('inventory'),
                  ),
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavBarWidget(gameRef: game), // Navbar stays visible
          ),
        ],
      ),
    ),
  );
}

/*
  player buys seed packs in the shop 
  player plants seeds 
  they grow over time 
  grown plants generate income over time or can be sold for a large profit
  different packs for earners, supporters, other categories
*/
