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
      money: fields[0] as int,
      pots: (fields[1] as List).cast<PotState>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.money)
      ..writeByte(1)
      ..write(obj.pots);
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

class PotStateAdapter extends TypeAdapter<PotState> {
  @override
  final int typeId = 1;

  @override
  PotState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PotState(
      x: fields[0] as double,
      y: fields[1] as double,
      currentFlower: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PotState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.currentFlower);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PotStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
