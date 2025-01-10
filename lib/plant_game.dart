import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:plant_game/screens/greenhouse_screen.dart';


class PlantGame extends FlameGame {
  late final RouterComponent router;

  PlantGame() : super();

  @override
  Future<void> onLoad() async {
    router = RouterComponent(
      initialRoute: 'greenhouse',
      routes: {
        'greenhouse': Route(() => GreenhouseScreen()),
        //'menu': Route(() => MenuScreen()),
        //'shop': Route(() => ShopScreen()),
        //'planting': Route(() => PlantingScreen()),
      },
    );
    add(router);
  }
}
