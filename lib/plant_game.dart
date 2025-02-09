import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'worlds/greenhouse_world.dart';
import 'components/tick_timer.dart';

class PlantGame extends FlameGame {
  late final RouterComponent router;
  late TickTimer tickTimer;
  //@override bool get debugMode => true; // Enables debug mode

  PlantGame() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final world = GreenhouseWorld();
    add(world);

    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
      world: world,
    );
    add(camera);

    router = RouterComponent(
      initialRoute: 'greenhouseWorld',
      routes: {
        'greenhouseWorld': WorldRoute(() => GreenhouseWorld()),
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
      ..priority = 0; 
    add(tickTimer);
  }
}

class GameData {
  int vegetables;

  GameData({this.vegetables = 0});
}
