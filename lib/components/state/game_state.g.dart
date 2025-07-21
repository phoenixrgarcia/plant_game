// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateAdapter extends TypeAdapter<GameState> {
  @override
  final int typeId = 0;

  @override
  GameState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameState(
      money: fields[0] as double,
      pots: (fields[1] as List)
          .map((dynamic e) => (e as List).cast<PotState>())
          .toList(),
      plantInventory: (fields[2] as List).cast<InventoryEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.money)
      ..writeByte(1)
      ..write(obj.pots)
      ..writeByte(2)
      ..write(obj.plantInventory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
