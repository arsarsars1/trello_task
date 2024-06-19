import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 3)
class TaskModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String task;
  @HiveField(2)
  final bool isCompleted;
  @HiveField(3)
  final DateTime completedAt;

  TaskModel({
    required this.id,
    required this.task,
    required this.isCompleted,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'task': task,
        'isCompleted': isCompleted,
        'completedAt': completedAt.toIso8601String(),
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      task: json['task'],
      isCompleted: json['isCompleted'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }
}
