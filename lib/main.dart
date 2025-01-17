import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'plant_game.dart';

void main() {
  final game = PlantGame();
  runApp(GameWidget(game: game));
}
/*
  player buys seed packs in the shop 
  player plants seeds 
  they grow over time 
  grown plants generate income over time or can be sold for a large profit
  different packs for earners, supporters, other categories
*/