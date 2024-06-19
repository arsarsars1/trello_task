import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/bloc/board/board_state.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/repositories/board_repository.dart';
import 'package:task_tracker_pro/utils/extension.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final BoardRepository boardRepository;

  BoardBloc(this.boardRepository) : super(BoardInitial()) {
    on<LoadBoardEvent>(_onLoadBoards);
    on<AddBoardEvent>(_onAddBoard);
    on<AddBoardItemEvent>(_onAddBoardItem);
    on<UpdateBoardItemEvent>(_onUpdateBoardItem);
    on<DeleteBoardItemEvent>(_onDeleteBoardItem);
    on<DeleteBoardEvent>(_onDeleteBoard);
    on<ReorderListEvent>(_onReorderList);
    on<ReorderListItemEvent>(_onReorderListItem);
  }

  Future<void> _onLoadBoards(
      LoadBoardEvent event, Emitter<BoardState> emit) async {
    emit(BoardLoading());
    try {
      final lists = boardRepository.getBoards();
      emit(BoardLoaded(lists: lists));
    } catch (e) {
      emit(BoardError(message: e.toString()));
    }
  }

  Future<void> _onAddBoard(
      AddBoardEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      final currentState = state as BoardLoaded;
      emit(BoardLoading());
      final updatedLists = List<DraggableModel>.from(currentState.lists)
        ..add(event.newBoard);
      await boardRepository.addBoard(event.newBoard);
      emit(BoardLoaded(lists: updatedLists));
    }
  }

  Future<void> _onDeleteBoard(
      DeleteBoardEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      final currentState = state as BoardLoaded;
      emit(BoardLoading());
      await boardRepository.removeBoards(currentState.lists);
      emit(const BoardLoaded(lists: []));
    }
  }

  Future<void> _onAddBoardItem(
      AddBoardItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      try {
        final currentState = state as BoardLoaded;
        emit(BoardLoading());
        var list = currentState.lists;
        if (list
            .any((DraggableModel model) => model.boardId == event.boardId)) {
          DraggableModel model = list
              .where((boardModel) => boardModel.boardId == event.boardId)
              .first;
          int index = list
              .indexWhere((boardModel) => boardModel.boardId == event.boardId);
          model.items.add(event.dragItem);
          list.update(index, model);
          await boardRepository.updateBoards(list);
          emit(BoardSuccess());
          emit(BoardLoaded(lists: list));
        }
      } catch (e) {
        emit(BoardError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateBoardItem(
      UpdateBoardItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      // try {
      final currentState = state as BoardLoaded;
      emit(BoardLoading());
      var list = currentState.lists;
      if (list.any((DraggableModel model) => model.boardId == event.boardId)) {
        DraggableModel model = list
            .where((boardModel) => boardModel.boardId == event.boardId)
            .first;
        int index = list
            .indexWhere((boardModel) => boardModel.boardId == event.boardId);

        var dragModelItemIndex = model.items
            .indexWhere((dragItem) => dragItem.boardId == event.boardId);

        model.items.update(dragModelItemIndex, event.dragItem);
        list.update(index, model);
        await boardRepository.updateBoards(list);
        emit(BoardSuccess());
        emit(BoardLoaded(lists: list));
      }
      // } catch (e) {
      //   emit(BoardError(message: e.toString()));
      // }
    }
  }

  Future<void> _onDeleteBoardItem(
      DeleteBoardItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      final currentState = state as BoardLoaded;
      emit(BoardLoading());
      var list = currentState.lists;
      DraggableModel model =
          list.where((boardModel) => boardModel.boardId == event.boardId).first;
      int index =
          list.indexWhere((boardModel) => boardModel.boardId == event.boardId);

      model.items.removeWhere(
          (dragItem) => dragItem.boardId == event.dragItem.boardId);
      list.update(index, model);
      await boardRepository.updateBoards(list);
      emit(BoardDeleted());
      emit(BoardLoaded(lists: list));
    }
  }

  Future<void> _onReorderList(
      ReorderListEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      final currentState = state as BoardLoaded;
      emit(BoardReOrder());
      final updatedLists = List<DraggableModel>.from(currentState.lists);
      final movedList = updatedLists.removeAt(event.oldListIndex);
      updatedLists.insert(event.newListIndex, movedList);
      await boardRepository.updateBoards(updatedLists);
      emit(BoardLoaded(lists: updatedLists));
    }
  }

  Future<void> _onReorderListItem(
      ReorderListItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded) {
      final currentState = state as BoardLoaded;
      emit(BoardReOrder());
      final updatedLists = List<DraggableModel>.from(currentState.lists);

      final oldListItems = updatedLists[event.oldListIndex].items;
      final newListItems = updatedLists[event.newListIndex].items;

      final movedItem = oldListItems.removeAt(event.oldItemIndex);

      movedItem.boardId = updatedLists[event.newListIndex].boardId;
      newListItems.insert(event.newItemIndex, movedItem);

      await boardRepository.updateBoards(updatedLists);
      emit(BoardLoaded(lists: updatedLists));
    }
  }
}
