// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PcrDbVersionAdapter extends TypeAdapter<PcrDbVersion> {
  @override
  final int typeId = 1;

  @override
  PcrDbVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PcrDbVersion(
      truthVersion: fields[0] as String,
      hash: fields[1] as String,
      prefabVer: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PcrDbVersion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.truthVersion)
      ..writeByte(1)
      ..write(obj.hash)
      ..writeByte(2)
      ..write(obj.prefabVer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PcrDbVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
