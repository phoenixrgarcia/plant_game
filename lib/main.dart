import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'plant_game.dart';

void main() {
  final game = PlantGame();
  runApp(GameWidget(game: game));
}