// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_instance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantInstanceAdapter extends TypeAdapter<PlantInstance> {
  @override
  final int typeId = 3;

  @override
  PlantInstance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantInstance(
      plantDataName: fields[0] as String,
      currentAge: fields[1] as int,
      tier: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlantInstance obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.plantDataName)
      ..writeByte(1)
      ..write(obj.currentAge)
      ..writeByte(2)
      ..write(obj.tier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantInstanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
