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