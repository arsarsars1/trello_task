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
        DraggableModel? model = list.safeFirstWhere(
            (boardModel) => boardModel.boardId == event.boardId);
        if (model != null) {
          model.items.add(event.dragItem);
          list.update(list.indexOf(model), model);
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
      try {
        final currentState = state as BoardLoaded;
        emit(BoardLoading());
        var list = currentState.lists;
        DraggableModel? draggableModel = list.safeFirstWhere(
            (DraggableModel model) => model.boardId == event.boardId);
        if (event.boardId == event.dragItem.boardId) {
          if (draggableModel != null) {
            int dragModelItemIndex = draggableModel.items.indexWhere(
                (dragItem) => dragItem.boardId == event.dragItem.boardId);

            draggableModel.items.safeUpdate(dragModelItemIndex, event.dragItem);
            list.safeUpdate(list.indexOf(draggableModel), draggableModel);
          }
        } else {
          DraggableModel? model = list.safeFirstWhere(
              (boardModel) => boardModel.boardId == event.dragItem.boardId);
          if (model != null && draggableModel != null) {
            draggableModel.items
                .safeRemoveWhere((dragItem) => dragItem.id == event.cardId);

            model.items.add(event.dragItem);
            list.safeUpdate(list.indexOf(model), model);
          }
        }
        await boardRepository.updateBoards(list);
        emit(BoardSuccessUpdate());
        emit(BoardLoaded(lists: list));
      } catch (e) {
        emit(BoardError(message: e.toString()));
      }
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

      model.items.removeWhere(
          (dragItem) => dragItem.boardId == event.dragItem.boardId);
      list.safeUpdate(list.indexOf(model), model);
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
      updateList(emit);
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

  updateList(Emitter<BoardState> emit) async {
    final lists = boardRepository.getBoards();
    lists.forEach((action) {
      print(action.header);
      action.items.forEach((actions) {
        print(actions.title);
      });
    });
    emit(BoardLoaded(lists: lists));
  }
}
