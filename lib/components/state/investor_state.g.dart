// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investor_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvestorStateAdapter extends TypeAdapter<InvestorState> {
  @override
  final int typeId = 6;

  @override
  InvestorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvestorState(
      investorsAttracted: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InvestorState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.investorsAttracted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
