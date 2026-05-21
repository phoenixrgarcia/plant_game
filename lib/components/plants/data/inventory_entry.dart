import 'dart:math' as Math;

import 'package:hive_flutter/hive_flutter.dart';

part 'inventory_entry.g.dart';

@HiveType(typeId: 2)
class InventoryEntry extends HiveObject {
  @HiveField(0)
  final String plantDataName;

  @HiveField(1)
  int totalCopies;

  @HiveField(2)
  int tier;

  @HiveField(3)
  bool isPlanted;

  InventoryEntry(
      {required this.plantDataName,
      required this.totalCopies,
      required this.tier,
      this.isPlanted = false});

  int get copiesToNextTier {
    return 2 + 2 * tier;
  }
}
