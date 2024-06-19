// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 0;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.High;
      case 1:
        return Priority.Medium;
      case 2:
        return Priority.Low;
      default:
        return Priority.High;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.High:
        writer.writeByte(0);
        break;
      case Priority.Medium:
        writer.writeByte(1);
        break;
      case Priority.Low:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
