// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upgrade_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpgradeStateAdapter extends TypeAdapter<UpgradeState> {
  @override
  final int typeId = 5;

  @override
  UpgradeState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpgradeState(
      upgradesPurchased: (fields[0] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, int>())),
      upgradesCost: (fields[1] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, int>())),
    );
  }

  @override
  void write(BinaryWriter writer, UpgradeState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.upgradesPurchased)
      ..writeByte(1)
      ..write(obj.upgradesCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpgradeStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
