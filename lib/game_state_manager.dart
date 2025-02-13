import 'package:hive_flutter/hive_flutter.dart';

class GameStateManager {
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox('gameState');
  }

  static Box get box {
    if (_box == null) {
      throw Exception("GameStateManager is not initialized.");
    }
    return _box!;
  }
}
