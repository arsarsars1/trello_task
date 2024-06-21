import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/bloc/board/board_state.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';
import 'package:task_tracker_pro/repositories/board_repository.dart';
import 'package:task_tracker_pro/utils/extension.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final BoardRepository boardRepository;

  BoardBloc(this.boardRepository) : super(const BoardInitial([])) {
    on<LoadBoardEvent>(_onLoadBoards);
    on<AddBoardEvent>(_onAddBoard);
    on<AddBoardItemEvent>(_onAddBoardItem);
    on<UpdateBoardItemEvent>(_onUpdateBoardItem);
    on<DeleteBoardItemEvent>(_onDeleteBoardItem);
    on<DeleteBoardEvent>(_onDeleteBoard);
    on<ReorderListEvent>(_onReorderList);
    on<ReorderListItemEvent>(_onReorderListItem);
    //Board Details
    on<StartTimerEvent>(_onStartTimer);
    on<StopTimerEvent>(_onStopTimer);
    on<CompleteTaskEvent>(_onCompleteTask);
    on<AddCommentEvent>(_onAddComment);
  }

  Future<void> _onLoadBoards(
      LoadBoardEvent event, Emitter<BoardState> emit) async {
    emit(BoardLoading(state.lists));
    try {
      final lists = boardRepository.getBoards();
      emit(BoardLoaded(lists: lists));
    } catch (e) {
      emit(BoardError(lists: state.lists, message: e.toString()));
    }
  }

  Future<void> _onAddBoard(
      AddBoardEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      emit(BoardLoading(state.lists));
      final updatedLists = List<DraggableModel>.from(state.lists)
        ..add(event.newBoard);
      await boardRepository.addBoard(event.newBoard);
      emit(BoardLoaded(lists: updatedLists));
    }
  }

  Future<void> _onDeleteBoard(
      DeleteBoardEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      emit(BoardLoading(state.lists));
      await boardRepository.removeBoards(state.lists);
      emit(const BoardLoaded(lists: []));
    }
  }

  Future<void> _onAddBoardItem(
      AddBoardItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      try {
        emit(BoardLoading(state.lists));
        var list = state.lists;
        DraggableModel? model = list.safeFirstWhere(
            (boardModel) => boardModel.boardId == event.boardId);

        if (model != null) {
          // var item = model.items.safeFirstWhere(
          //     (dragItem) => dragItem.title == event.dragItem.title);

          model.items.add(event.dragItem);
          list.update(list.indexOf(model), model);
          if (checkDuplicateTitles(list)) {
            emit(BoardErrorSameName(state.lists));
            emit(BoardLoaded(lists: list));
          } else {
            await boardRepository.updateBoards(list);
            emit(BoardSuccess(state.lists));
            emit(BoardLoaded(lists: list));
          }
        }
      } catch (e) {
        emit(BoardError(lists: state.lists, message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateBoardItem(
      UpdateBoardItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      try {
        emit(BoardLoading(state.lists));
        var list = state.lists;
        DraggableModel? draggableModel = list.safeFirstWhere(
            (DraggableModel model) => model.boardId == event.boardId);
        if (event.boardId == event.dragItem.boardId) {
          if (draggableModel != null) {
            int dragModelItemIndex = draggableModel.items.indexWhere(
                (dragItem) => dragItem.boardId == event.dragItem.boardId);

            draggableModel.items.safeUpdate(dragModelItemIndex, event.dragItem);
            list.safeUpdate(list.indexOf(draggableModel), draggableModel);
            await boardRepository.updateBoard(draggableModel);
          }
        } else {
          DraggableModel? model = list.safeFirstWhere(
              (boardModel) => boardModel.boardId == event.dragItem.boardId);
          if (model != null && draggableModel != null) {
            draggableModel.items
                .safeRemoveWhere((dragItem) => dragItem.id == event.cardId);

            model.items.add(event.dragItem);

            list.safeUpdate(list.indexOf(model), model);
            await boardRepository.updateBoard(draggableModel);
          }
        }
        emit(BoardSuccessUpdate(state.lists));
        emit(BoardLoaded(lists: list));
      } catch (e) {
        emit(BoardError(lists: state.lists, message: e.toString()));
      }
    }
  }

  bool checkDuplicateTitles(List<DraggableModel> draggableModels) {
    Set<String> titles = {};
    Set<String> header = {};

    for (var model in draggableModels) {
      if (header.contains(model.header)) {
        return true;
      }
      header.add(model.header);
      for (var item in model.items) {
        if (titles.contains(item.title)) {
          return true;
        }
        titles.add(item.title);
      }
    }

    return false;
  }

  Future<void> _onDeleteBoardItem(
      DeleteBoardItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      emit(BoardLoading(state.lists));
      var list = state.lists;
      DraggableModel model =
          list.where((boardModel) => boardModel.boardId == event.boardId).first;

      model.items.removeWhere(
          (dragItem) => dragItem.boardId == event.dragItem.boardId);
      list.safeUpdate(list.indexOf(model), model);
      await boardRepository.updateBoards(list);
      emit(BoardDeleted(state.lists));
      emit(BoardLoaded(lists: list));
    }
  }

  Future<void> _onReorderList(
      ReorderListEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      emit(BoardReOrder(state.lists));
      final updatedLists = List<DraggableModel>.from(state.lists);
      final movedList = updatedLists.removeAt(event.oldListIndex);
      updatedLists.insert(event.newListIndex, movedList);

      await boardRepository.updateBoardsListIndex(updatedLists);
      emit(BoardLoaded(lists: updatedLists));
    }
  }

  Future<void> _onReorderListItem(
      ReorderListItemEvent event, Emitter<BoardState> emit) async {
    if (state is BoardLoaded || state is BoardRunning) {
      emit(BoardReOrder(state.lists));
      final updatedLists = List<DraggableModel>.from(state.lists);

      final oldListItems = updatedLists[event.oldListIndex].items;
      final newListItems = updatedLists[event.newListIndex].items;

      final movedItem = oldListItems.removeAt(event.oldItemIndex);

      movedItem.boardId = updatedLists[event.newListIndex].boardId;
      newListItems.insert(event.newItemIndex, movedItem);

      await boardRepository.updateBoardsListIndex(updatedLists);
      emit(BoardLoaded(lists: updatedLists));
    }
  }

  Future<void> _onStartTimer(
      StartTimerEvent event, Emitter<BoardState> emit) async {
    final stopwatch = Stopwatch();

    event.task.startDateTime = DateTime.now().toIso8601String();

    final list = await updateBoard(event.task.boardId, event.task);

    stopwatch.start();
    emit(BoardRunning(
      lists: list,
      task: event.task,
      stopwatch: stopwatch,
      elapsedTime: Duration.zero,
    ));

    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (stopwatch.isRunning) {
        emit(BoardRunning(
          lists: state.lists,
          task: event.task,
          stopwatch: stopwatch,
          elapsedTime: stopwatch.elapsed,
        ));
        return true;
      }
      return false;
    });
  }

  Future<void> _onStopTimer(
      StopTimerEvent event, Emitter<BoardState> emit) async {
    if (state is BoardRunning) {
      final runningState = state as BoardRunning;
      runningState.stopwatch.stop();
      event.task.startDateTime = null;

      final list = await updateBoard(event.task.boardId, event.task);

      emit(BoardLoaded(lists: list));
    }
  }

  Future<void> _onCompleteTask(
      CompleteTaskEvent event, Emitter<BoardState> emit) async {
    if (state is BoardRunning) {
      final runningState = state as BoardRunning;
      runningState.stopwatch.stop();
      runningState.task.timeSpent = runningState.stopwatch.elapsed;
      runningState.task.completedDate = DateTime.now().toIso8601String();

      final list =
          await updateBoard(runningState.task.boardId, runningState.task);

      emit(BoardLoaded(lists: list));
      runningState.stopwatch.reset();
    }
  }

  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<BoardState> emit) async {
    final task = event.task;
    task.comment.add(event.comment);

    final list = await updateBoard(task.boardId, task);

    emit(BoardLoaded(lists: list));
  }

  Future<List<DraggableModel>> updateBoard(
      String boardId, DraggableModelItem dragItem) async {
    final list = state.lists;
    DraggableModel? draggableModel =
        list.safeFirstWhere((DraggableModel model) => model.boardId == boardId);
    if (boardId == dragItem.boardId) {
      if (draggableModel != null) {
        int dragModelItemIndex = draggableModel.items
            .indexWhere((dragItem) => dragItem.boardId == dragItem.boardId);

        draggableModel.items.safeUpdate(dragModelItemIndex, dragItem);
        list.safeUpdate(list.indexOf(draggableModel), draggableModel);
        await boardRepository.updateBoard(draggableModel);
        return list;
      }
    }
    return list;
  }
}
