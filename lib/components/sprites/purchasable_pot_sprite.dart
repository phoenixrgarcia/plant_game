

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:flame/text.dart';

class PurchasablePot extends SpriteComponent with HasGameRef<PlantGame>, TapCallbacks{
  final int row;
  final int col;
  final GameStateManager gameStateManager = GameStateManager();
  late final Sprite plusSprite;
  final _costPaint = TextPaint(
    style: const TextStyle(
      fontSize: 20,
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
  );

  PurchasablePot({required this.row, required this.col, required Vector2 size, required Vector2 position})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load the initial pot sprite (this would be a generic pot image)
    sprite = await gameRef.loadSprite('sample_pot_grey.png');
    plusSprite = await gameRef.loadSprite('plus_icon.png');
  }

  @override
  bool onTapDown(TapDownEvent event) {
    gameRef.greenhouseWorld.purchasePot(row, col);
    return true; 
  }

  @override
  void render(Canvas canvas) {
    if(gameStateManager.state.money > gameStateManager.state.potCost){
      plusSprite.render(canvas);
    } 
    
    super.render(canvas);

    _costPaint.render(
      canvas,
      '\$${gameStateManager.state.potCost.toStringAsFixed(0)}',
      Vector2(size.x / 2 - 20, size.y + 5),
      anchor: Anchor.topLeft,
    );
  }
}