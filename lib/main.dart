import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_game/game_state_manager.dart';
import 'plant_game.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
  await Hive.initFlutter();

  await GameStateManager.init(); // Initialize the manager and open the box

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