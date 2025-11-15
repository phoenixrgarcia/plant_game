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
      currentAge: fields[1] as double,
      tier: fields[2] as int,
      addBonus: fields[3] as double,
      multBonus: fields[4] as double,
      flatBonus: fields[5] as double,
      exponentialBonus: fields[6] as double,
      tickRateFlat: fields[7] as double,
      tickRateMult: fields[8] as double,
      tickProgress: fields[9] as double,
      isFullyGrown: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlantInstance obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.plantDataName)
      ..writeByte(1)
      ..write(obj.currentAge)
      ..writeByte(2)
      ..write(obj.tier)
      ..writeByte(3)
      ..write(obj.addBonus)
      ..writeByte(4)
      ..write(obj.multBonus)
      ..writeByte(5)
      ..write(obj.flatBonus)
      ..writeByte(6)
      ..write(obj.exponentialBonus)
      ..writeByte(7)
      ..write(obj.tickRateFlat)
      ..writeByte(8)
      ..write(obj.tickRateMult)
      ..writeByte(9)
      ..write(obj.tickProgress)
      ..writeByte(10)
      ..write(obj.isFullyGrown);
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
