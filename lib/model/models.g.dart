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

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 5;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int,
      canAuto: (fields[1] as List).cast<int>(),
      stage: fields[2] as int,
      damage: fields[3] as int,
      autoDamage: fields[4] as int?,
      charas: (fields[5] as List).cast<Chara>(),
      remarks: fields[6] as String,
      exRemarks: fields[9] as String,
      links: (fields[7] as List).cast<Link>(),
      type: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.canAuto)
      ..writeByte(2)
      ..write(obj.stage)
      ..writeByte(3)
      ..write(obj.damage)
      ..writeByte(4)
      ..write(obj.autoDamage)
      ..writeByte(5)
      ..write(obj.charas)
      ..writeByte(6)
      ..write(obj.remarks)
      ..writeByte(7)
      ..write(obj.links)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.exRemarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharaAdapter extends TypeAdapter<Chara> {
  @override
  final int typeId = 3;

  @override
  Chara read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chara(
      prefabId: fields[0] as int,
      unitName: fields[1] as String,
      rarity: fields[2] as int?,
      searchAreaWidth: fields[3] as int,
      rank: fields[4] as int?,
      currentRarity: fields[5] as int?,
      id: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Chara obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.prefabId)
      ..writeByte(1)
      ..write(obj.unitName)
      ..writeByte(2)
      ..write(obj.rarity)
      ..writeByte(3)
      ..write(obj.searchAreaWidth)
      ..writeByte(4)
      ..write(obj.rank)
      ..writeByte(5)
      ..write(obj.currentRarity)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkAdapter extends TypeAdapter<Link> {
  @override
  final int typeId = 6;

  @override
  Link read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Link(
      name: fields[0] as String,
      link: fields[1] as String,
      remarks: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Link obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GvgTaskFilterHiveAdapter extends TypeAdapter<GvgTaskFilterHive> {
  @override
  final int typeId = 2;

  @override
  GvgTaskFilterHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GvgTaskFilterHive(
      server: fields[0] as String,
      bossNumber: (fields[1] as List).cast<int>(),
      methods: (fields[2] as List).cast<int>(),
      clanBattleId: fields[3] as int,
      startTime: fields[5] as String,
      stage: fields[4] as int,
      usedOrRemoved: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GvgTaskFilterHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.server)
      ..writeByte(1)
      ..write(obj.bossNumber)
      ..writeByte(2)
      ..write(obj.methods)
      ..writeByte(3)
      ..write(obj.clanBattleId)
      ..writeByte(4)
      ..write(obj.stage)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.usedOrRemoved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GvgTaskFilterHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskFilterResultAdapter extends TypeAdapter<TaskFilterResult> {
  @override
  final int typeId = 4;

  @override
  TaskFilterResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskFilterResult(
      bossId: fields[0] as int,
      prefabId: fields[1] as int,
      index: fields[3] as int,
      fixedBorrowChara: fields[5] as Chara?,
      task: fields[4] as Task,
      borrowChara: fields[2] as Chara?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskFilterResult obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bossId)
      ..writeByte(1)
      ..write(obj.prefabId)
      ..writeByte(2)
      ..write(obj.borrowChara)
      ..writeByte(3)
      ..write(obj.index)
      ..writeByte(4)
      ..write(obj.task)
      ..writeByte(5)
      ..write(obj.fixedBorrowChara);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskFilterResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
