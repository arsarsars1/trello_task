// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draggable_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraggableModelAdapter extends TypeAdapter<DraggableModel> {
  @override
  final int typeId = 5;

  @override
  DraggableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraggableModel(
      color: fields[1] as Color,
      boardId: fields[0] as String,
      dateTime: fields[2] as DateTime,
      header: fields[3] as String,
      items: (fields[4] as List).cast<DraggableModelItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, DraggableModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.boardId)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.header)
      ..writeByte(4)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraggableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
