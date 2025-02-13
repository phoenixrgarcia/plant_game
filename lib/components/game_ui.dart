import 'package:flame/components.dart';
import 'package:plant_game/components/UI/nav_bar.dart';

import 'UI/tick_timer.dart';

class GameUI extends Component {
  late final TickTimer tickTimer;

  GameUI(Vector2 gameSize) {
    tickTimer = TickTimer(tickRate: 5.0)
      ..size = Vector2(gameSize.x * 0.3, gameSize.y * 0.05) // 30% width, 5% height
      ..position = Vector2(gameSize.x * 0.05, gameSize.y * 0.05) // Top-left corner
      ..priority = 100; // Always above other components

    add(tickTimer);
    add(NavBarComponent(screenSize: gameSize)..priority = 100);  
  }
}
