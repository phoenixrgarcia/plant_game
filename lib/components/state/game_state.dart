import 'package:hive/hive.dart';
import 'package:plant_game/components/state/pot_state.dart';

part 'game_state.g.dart';

@HiveType(typeId: 0)
class GameState {
  @HiveField(0)
  int money;

  @HiveField(1)
  List<List<PotState>> pots;

  GameState({this.money = 0, required this.pots});
}
