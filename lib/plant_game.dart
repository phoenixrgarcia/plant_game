import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'screens/greenhouse_screen.dart';
import 'components/tick_timer.dart';

class PlantGame extends FlameGame {
  late final RouterComponent router;
  late TickTimer tickTimer;
  //@override bool get debugMode => true; // Enables debug mode

  PlantGame() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    router = RouterComponent(
      initialRoute: 'greenhouse',
      routes: {
        'greenhouse': Route(() => GreenhouseScreen() .. priority = 0),
        //'menu': Route(() => MenuScreen()),
        //'shop': Route(() => ShopScreen()),
        //'planting': Route(() => PlantingScreen()),
      },
    );
    add(router);

    // Add the timer as a child of the router to keep it above the screens
    tickTimer = TickTimer(tickRate: 5.0) // Adjust tickRate as needed
      ..size = Vector2(size.x * 0.3, size.y * 0.05) // 30% width, 5% height
      ..position = Vector2(size.x * 0.05, size.y * 0.05) // Top-left corner
      ..priority = 1; 
    add(tickTimer);
  }
}

class GameData {
  int vegetables;

  GameData({this.vegetables = 0});
}
