import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';

class Plant {
  final String name;
  final String type;
  final double growthTime;
  final double sellPrice;
  final double incomeRate;
  final double tickRate;
  final int rarity;
  final String imagePath;
  final String spritePath;
  final void Function(PotState self, GameStateManager gameStateManager) onTick;
  final void Function() onHarvest;
  final void Function(PotState self, GameStateManager gameStateManager) onGrow;
  final String? description;
  final String? specialProperties;

  Plant({
    required this.name,
    required this.type,
    required this.growthTime,
    required this.sellPrice,
    required this.incomeRate,
    required this.tickRate,
    required this.rarity,
    required this.imagePath,
    required this.spritePath,
    required this.onTick,
    required this.onHarvest,
    required this.onGrow,
    this.description,
    this.specialProperties,
  });



  Future<Sprite> loadSprite(Images images) async {
    return Sprite(images.fromCache(spritePath));
  }
}
