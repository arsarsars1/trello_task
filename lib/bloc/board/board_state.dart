import 'package:equatable/equatable.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';

// Base state class with list data
abstract class BoardState extends Equatable {
  final List<DraggableModel> lists;

  const BoardState(this.lists);

  @override
  List<Object> get props => [lists];
}

class BoardInitial extends BoardState {
  const BoardInitial(super.lists);
}

class BoardLoading extends BoardState {
  const BoardLoading(super.lists);
}

class BoardLoaded extends BoardState {
  const BoardLoaded({
    required List<DraggableModel> lists,
  }) : super(lists);
}

class BoardSuccess extends BoardState {
  const BoardSuccess(super.lists);
}

class BoardErrorSameName extends BoardState {
  const BoardErrorSameName(super.lists);
}

class BoardSuccessUpdate extends BoardState {
  const BoardSuccessUpdate(super.lists);
}

class BoardReOrder extends BoardState {
  const BoardReOrder(super.lists);
}

class BoardDeleted extends BoardState {
  const BoardDeleted(super.lists);
}

class BoardError extends BoardState {
  final String message;

  const BoardError({required this.message, required List<DraggableModel> lists})
      : super(lists);

  @override
  List<Object> get props => [message, ...super.props];
}

class BoardRunning extends BoardState {
  final DraggableModelItem task;
  final Stopwatch stopwatch;
  final Duration elapsedTime;

  const BoardRunning({
    required List<DraggableModel> lists,
    required this.task,
    required this.stopwatch,
    required this.elapsedTime,
  }) : super(lists);

  @override
  List<Object> get props => [task, stopwatch, elapsedTime, ...super.props];
}

class BoardCompleted extends BoardState {
  final DraggableModelItem completedTask;

  const BoardCompleted(
      {required List<DraggableModel> lists, required this.completedTask})
      : super(lists);

  @override
  List<Object> get props => [completedTask, ...super.props];
}

class BoardCommentAdded extends BoardState {
  final DraggableModelItem task;

  const BoardCommentAdded(
      {required List<DraggableModel> lists, required this.task})
      : super(lists);

  @override
  List<Object> get props => [task, ...super.props];
}
