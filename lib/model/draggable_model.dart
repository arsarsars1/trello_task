import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';

part 'draggable_model.g.dart';

@HiveType(typeId: 5)
class DraggableModel extends HiveObject {
  @HiveField(0)
  final String boardId;
  @HiveField(1)
  final Color color;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final String header;
  @HiveField(4)
  List<DraggableModelItem> items;

  DraggableModel({
    this.color = Colors.black,
    required this.boardId,
    required this.dateTime,
    required this.header,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'boardId': boardId,
        'color': color.value,
        'dateTime': dateTime.toIso8601String(),
        'header': header,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory DraggableModel.fromJson(Map<String, dynamic> json) {
    return DraggableModel(
      boardId: json['boardId'],
      color: Color(json['color']),
      dateTime: DateTime.parse(json['dateTime']),
      header: json['header'],
      items: (json['items'] as List)
          .map((item) => DraggableModelItem.fromJson(item))
          .toList(),
    );
  }
}
