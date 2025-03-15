import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/game_state_manager.dart';

import '../plant_game.dart';
import 'state/game_state.dart';

class MoneyDisplay extends TextComponent with HasGameRef<PlantGame> {
  MoneyDisplay() : super(priority: 10);
  dynamic gameState;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var box = GameStateManager.box;
    gameState = box.get('currentGameState', defaultValue: GameState(money: 0, pots: []));

    text = 'Money: ${gameState.money}';
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
    );

  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the displayed currency
    text = 'Money: ${gameState.money}';
  }
}
