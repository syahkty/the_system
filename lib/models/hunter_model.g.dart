// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryItemAdapter extends TypeAdapter<InventoryItem> {
  @override
  final int typeId = 2;

  @override
  InventoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryItem(
      name: fields[0] as String,
      icon: fields[1] as String,
      quantity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HunterModelAdapter extends TypeAdapter<HunterModel> {
  @override
  final int typeId = 0;

  @override
  HunterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HunterModel(
      name: fields[0] as String,
      level: fields[1] as int,
      currentXp: fields[2] as int,
      maxXp: fields[3] as int,
      rank: fields[4] as String,
      strength: fields[5] as int,
      intelligence: fields[6] as int,
      artistry: fields[8] as int,
      vitality: fields[9] as int,
      charisma: fields[10] as int,
      gold: fields[7] as int,
      dailyStreak: fields[12] == null ? 0 : fields[12] as int,
      lastLoginDate: fields[13] as DateTime?,
      inventory: fields[11] == null
          ? []
          : (fields[11] as List?)?.cast<InventoryItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, HunterModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.currentXp)
      ..writeByte(3)
      ..write(obj.maxXp)
      ..writeByte(4)
      ..write(obj.rank)
      ..writeByte(5)
      ..write(obj.strength)
      ..writeByte(6)
      ..write(obj.intelligence)
      ..writeByte(8)
      ..write(obj.artistry)
      ..writeByte(9)
      ..write(obj.vitality)
      ..writeByte(10)
      ..write(obj.charisma)
      ..writeByte(7)
      ..write(obj.gold)
      ..writeByte(11)
      ..write(obj.inventory)
      ..writeByte(12)
      ..write(obj.dailyStreak)
      ..writeByte(13)
      ..write(obj.lastLoginDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HunterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
