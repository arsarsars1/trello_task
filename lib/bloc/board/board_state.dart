import 'package:equatable/equatable.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';

abstract class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object> get props => [];
}

class BoardInitial extends BoardState {}

class BoardReOrder extends BoardState {}

class BoardLoading extends BoardState {}

class BoardSuccess extends BoardState {}

class BoardDeleted extends BoardState {}

class BoardLoaded extends BoardState {
  final List<DraggableModel> lists;

  const BoardLoaded({required this.lists});

  @override
  List<Object> get props => [lists];
}

class BoardError extends BoardState {
  final String message;

  const BoardError({required this.message});

  @override
  List<Object> get props => [message];
}
