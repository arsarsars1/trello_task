import 'package:hive/hive.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';

class BoardRepository {
  final Box<DraggableModel> boardBox;

  BoardRepository(this.boardBox);

  List<DraggableModel> getBoards() => boardBox.values.toList();

  Future<void> addBoard(DraggableModel board) async {
    await boardBox.put(board.header, board);
  }

  Future<void> updateBoard(DraggableModel board) async {
    await board.save();
  }

  Future<void> removeBoardItem(DraggableModel boardModel) async {
    await boardModel.delete();
  }

  DraggableModel? getBoardById(String header) {
    return boardBox.get(header);
  }

  bool isDataExist() => boardBox.isNotEmpty;

  // Add a whole list of boards
  Future<void> addBoards(List<DraggableModel> boards) async {
    final Map<String, DraggableModel> boardMap = {
      for (var board in boards) board.header: board
    };
    await boardBox.putAll(boardMap);
  }

  Future<void> addBoardsList(List<DraggableModel> boards) async =>
      await boardBox.addAll(boards);

  // Update a whole list of boards
  Future<void> updateBoards(List<DraggableModel> boards) async {
    for (var board in boards) {
      await boardBox.put(board.header, board);
    }
  }

  Future<void> updateBoardsListIndex(List<DraggableModel> boards) async {
    await boardBox.clear();
    await addBoardsList(boards);
  }

  // Remove a whole list of boards
  Future<void> removeBoards(List<DraggableModel> boards) async {
    for (var board in boards) {
      await board.delete();
    }
  }
}
