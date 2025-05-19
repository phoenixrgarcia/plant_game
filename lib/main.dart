import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_game/components/UI/nav_bar.dart';
import 'package:plant_game/components/UI/game_ui.dart';
import 'package:plant_game/components/money_display.dart';
import 'package:plant_game/components/plants/data/inventory_entry.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/screens/inventory_screen.dart';
import 'plant_game.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/shop_screen.dart';

// This file is the entry point of the app. This is where you add different overlays and screens to the game.

void main() async {
  // Initialize Hive, which contains game save state
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
  await Hive.initFlutter();

  await GameStateManager.init(); // Initialize the manager and open the box

  // To be deleted
  if(true){
    var state = GameState(pots: [[]], plantInventory: [InventoryEntry(plantDataName: 'tomato', quantity: 1)]);
    GameStateManager.saveState(state);
  }

  final game = PlantGame();

  // Create a GlobalKey to access the InventoryScreen's state
  final GlobalKey<InventoryScreenState> inventoryScreenKey =
      GlobalKey<InventoryScreenState>();

  // Runs the app. Add different overlays here. Overlays should be things that display on top of the 'game'
  // game is the greenhouse world.
  runApp(
    MaterialApp(
      home: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'shop': (_, __) => const ShopScreen(),
              'inventory': (_, __) => InventoryScreen(
                    key: inventoryScreenKey, // Assign the GlobalKey here
                    onClose: () {
                      game.greenhouseWorld.deselectPot();
                      game.overlays.remove('inventory');
                    },
                    plantInventory:
                        GameStateManager.currentState.plantInventory,
                    onPlant: (entry) {
                      // Perform the planting action
                      game.greenhouseWorld.plant(entry);
                      print("Planted ${entry.plantDataName}");

                      // Update the inventory after planting
                      inventoryScreenKey.currentState?.updateInventory(
                        GameStateManager.currentState.plantInventory,
                      );
                    },
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
