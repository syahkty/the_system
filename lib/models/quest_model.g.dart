// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestModelAdapter extends TypeAdapter<QuestModel> {
  @override
  final int typeId = 1;

  @override
  QuestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      xpReward: fields[3] as int,
      difficulty: fields[4] as String,
      isCompleted: fields[5] as bool,
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.xpReward)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
