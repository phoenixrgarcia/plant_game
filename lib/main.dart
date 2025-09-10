import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/components/UI/nav_bar.dart';
import 'package:plant_game/components/money_display.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/game_state_provider.dart';
import 'package:plant_game/screens/inventory_screen.dart';
import 'package:plant_game/screens/plant_info_screen.dart';
import 'components/UI/purchase_pot_dialog.dart';
import 'plant_game.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/shop_screen.dart';

// This file is the entry point of the app. This is where you add different overlays and screens to the game.

void main() async {
  // Initialize Hive, which contains game save state
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
  await Hive.initFlutter();

  // To be deleted
  if (true) {
    GameStateManager().clear();
  }
  await Hive.deleteBoxFromDisk('gameState');

  await GameStateManager().init(); // Initialize the manager and open the box

  final container = ProviderContainer();
  final gameStateManager = container.read(gameStateManagerProvider);

  final game = PlantGame(gameStateManager: gameStateManager);

  // Runs the app. Add different overlays here. Overlays should be things that display on top of the 'game'
  // game is the greenhouse world.
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                'shop': (_, __) => ShopScreen(
                      onBuy: handleShopBuy,
                    ),
                'inventory': (_, __) => InventoryScreen(
                      onClose: () {
                        game.greenhouseWorld.deselectPot();
                        game.overlays.remove('inventory');
                      },
                      selectedPotNotifier: game.greenhouseWorld.selectedPot,
                    ),
                'money': (_, __) => const Positioned(
                      top: 16,
                      right: 24,
                      child: MoneyDisplay(),
                    ),
                'plant_info': (_, __) => PlantInfoScreen(
                      onClose: () {
                        game.greenhouseWorld.deselectPot();
                        game.overlays.remove('plant_info');
                      },
                      selectedPotNotifier: game.greenhouseWorld.selectedPot,
                    ),
                'purchase_pot_dialog': (_, __) => PurchasePotDialog(
                      onConfirm: () {
                        game.overlays.remove('purchase_pot_dialog');
                        game.greenhouseWorld.purchasePot(
                            game.greenhouseWorld.pendingPotRow!,
                            game.greenhouseWorld.pendingPotCol!);
                      },
                      onCancel: () {
                        game.overlays.remove('purchase_pot_dialog');
                      },
                      cost: gameStateManager.state.potCost,
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
    ),
  );
}

void handleShopBuy(String itemName, int price) {
  // TODO
}
