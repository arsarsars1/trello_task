import 'package:hive/hive.dart';
import 'package:task_tracker_pro/model/priority.dart';

import 'comment_model.dart';
import 'contact.dart';
import 'task_model.dart';

part 'draggable_model_item.g.dart';

@HiveType(typeId: 1)
class DraggableModelItem extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final Priority priority;
  @HiveField(4)
  final String urlImage;
  @HiveField(5)
  final List<CommentModel> comment;
  @HiveField(6)
  final DateTime startTime;
  @HiveField(7)
  final DateTime endTime;
  @HiveField(8)
  final String createdAt;
  @HiveField(9)
  final String category;
  @HiveField(10)
  String boardId;
  @HiveField(11)
  final List<TaskModel> tasks;
  @HiveField(12)
  final List<Contact> peoples;

  DraggableModelItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.urlImage = "",
    required this.comment,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.category,
    required this.boardId,
    required this.tasks,
    required this.peoples,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority.index,
        'urlImage': urlImage,
        'comment': comment.map((e) => e.toJson()).toList(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'createdAt': createdAt,
        'category': category,
        'boardId': boardId,
        'tasks': tasks.map((e) => e.toJson()).toList(),
        'peoples': peoples.map((e) => e.toJson()).toList(),
      };

  factory DraggableModelItem.fromJson(Map<String, dynamic> json) {
    return DraggableModelItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: Priority.values[json['priority']],
      urlImage: json['urlImage'],
      comment: (json['comment'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      createdAt: json['createdAt'],
      category: json['category'],
      boardId: json['boardId'],
      tasks: (json['tasks'] as List).map((e) => TaskModel.fromJson(e)).toList(),
      peoples:
          (json['peoples'] as List).map((e) => Contact.fromJson(e)).toList(),
    );
  }
}
