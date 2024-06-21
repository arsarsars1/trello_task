// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draggable_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraggableModelItemAdapter extends TypeAdapter<DraggableModelItem> {
  @override
  final int typeId = 1;

  @override
  DraggableModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraggableModelItem(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      priority: fields[3] as Priority,
      urlImage: fields[4] as String,
      comment: (fields[5] as List).cast<CommentModel>(),
      startTime: fields[6] as DateTime,
      endTime: fields[7] as DateTime,
      createdAt: fields[8] as String,
      category: fields[9] as String,
      boardId: fields[10] as String,
      tasks: (fields[11] as List).cast<TaskModel>(),
      peoples: (fields[12] as List).cast<Contact>(),
      timeSpent: fields[13] as Duration?,
      completedDate: fields[14] as String?,
      startDateTime: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DraggableModelItem obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.urlImage)
      ..writeByte(5)
      ..write(obj.comment)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.endTime)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.boardId)
      ..writeByte(11)
      ..write(obj.tasks)
      ..writeByte(12)
      ..write(obj.peoples)
      ..writeByte(13)
      ..write(obj.timeSpent)
      ..writeByte(14)
      ..write(obj.completedDate)
      ..writeByte(15)
      ..write(obj.startDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraggableModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
