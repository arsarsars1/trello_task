import 'package:equatable/equatable.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class LoadBoardEvent extends BoardEvent {}

class ReorderListEvent extends BoardEvent {
  final int oldListIndex;
  final int newListIndex;

  const ReorderListEvent(this.oldListIndex, this.newListIndex);

  @override
  List<Object> get props => [oldListIndex, newListIndex];
}

class ReorderListItemEvent extends BoardEvent {
  final int oldItemIndex;
  final int oldListIndex;
  final int newItemIndex;
  final int newListIndex;

  const ReorderListItemEvent(
    this.oldItemIndex,
    this.oldListIndex,
    this.newItemIndex,
    this.newListIndex,
  );

  @override
  List<Object> get props =>
      [oldItemIndex, oldListIndex, newItemIndex, newListIndex];
}

class AddBoardEvent extends BoardEvent {
  final DraggableModel newBoard;

  const AddBoardEvent(this.newBoard);

  @override
  List<Object> get props => [newBoard];
}

class AddBoardItemEvent extends BoardEvent {
  final String boardId;
  final DraggableModelItem dragItem;

  const AddBoardItemEvent({
    required this.boardId,
    required this.dragItem,
  });

  @override
  List<Object> get props => [dragItem, boardId];
}

class UpdateBoardItemEvent extends BoardEvent {
  final int cardId;
  final String boardId;
  final DraggableModelItem dragItem;

  const UpdateBoardItemEvent({
    required this.cardId,
    required this.boardId,
    required this.dragItem,
  });

  @override
  List<Object> get props => [dragItem, cardId, boardId];
}

class DeleteBoardItemEvent extends BoardEvent {
  final String boardId;
  final DraggableModelItem dragItem;

  const DeleteBoardItemEvent({
    required this.boardId,
    required this.dragItem,
  });

  @override
  List<Object> get props => [dragItem, boardId];
}

class DeleteBoardEvent extends BoardEvent {
  const DeleteBoardEvent();

  @override
  List<Object> get props => [];
}
