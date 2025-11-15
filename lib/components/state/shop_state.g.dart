// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopStateAdapter extends TypeAdapter<ShopState> {
  @override
  final int typeId = 4;

  @override
  ShopState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopState(
      unlockedPlantTypes: (fields[0] as Map?)?.cast<String, bool>(),
      seedTierUpgradeLevel: (fields[1] as Map?)?.cast<String, int>(),
      seedCostMap: (fields[2] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<int>())),
    );
  }

  @override
  void write(BinaryWriter writer, ShopState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.unlockedPlantTypes)
      ..writeByte(1)
      ..write(obj.seedTierUpgradeLevel)
      ..writeByte(2)
      ..write(obj.seedCostMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
