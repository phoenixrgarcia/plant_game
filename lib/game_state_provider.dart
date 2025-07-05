import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/game_state_manager.dart';

final gameStateManagerProvider = ChangeNotifierProvider<GameStateManager>((ref) {
  return GameStateManager();
});