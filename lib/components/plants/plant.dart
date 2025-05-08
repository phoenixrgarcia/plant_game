import 'package:flame/cache.dart';
import 'package:flame/components.dart';

abstract class Plant {
  final String name;
  final int growthTime;
  final int sellPrice;
  final int incomeRate;
  final String spritePath;
  final void Function()? onHarvest;
  final void Function()? onTick;

  Plant({
    required this.name,
    required this.growthTime,
    required this.sellPrice,
    required this.incomeRate,
    required this.spritePath,
    this.onHarvest,
    this.onTick,
  });
}
