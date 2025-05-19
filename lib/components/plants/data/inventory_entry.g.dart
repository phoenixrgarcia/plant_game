// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryEntryAdapter extends TypeAdapter<InventoryEntry> {
  @override
  final int typeId = 2;

  @override
  InventoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryEntry(
      plantDataName: fields[0] as String,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.plantDataName)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
