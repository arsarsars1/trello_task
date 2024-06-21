import 'package:task_tracker_pro/model/draggable_model_item.dart';

class TaskState {
  final DraggableModelItem task;
  final Stopwatch stopwatch;

  TaskState({required this.task, required this.stopwatch});
}
