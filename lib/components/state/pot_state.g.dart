// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pot_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      currentPlant: fields[2] as PlantInstance?,
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
      ..write(obj.currentPlant);
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
