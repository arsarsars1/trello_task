# Task Tracker Pro

Task Tracker Pro is a project management application that allows users to manage tasks, prioritize them, add comments, and track time spent on tasks. The application uses Hive for local data storage.

## Features

- Create and manage boards.
- Add, update, and remove tasks within boards.
- Prioritize tasks.
- Add comments to tasks.
- Track time spent on tasks.
- View tasks with detailed information.


## Dependencies

- Flutter SDK
- Hive
- Hive Flutter
- Bloc
- GoRouter
- Path Provider

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/arsarsars1/trello_task.git
cd task-tracker-pro
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Generate Hive Adapters**

```bash
flutter packages pub run build_runner build
```

4. **Run the app**

```bash
flutter run
```

## Usage

### Creating a New Board

To create a new board, use the `addBoard` method from the `BoardRepository` class.

```dart
final board = DraggableModel(header: 'New Board', items: []);
await boardRepository.addBoard(board);
```

### Adding a Task to a Board

To add a task to a board, create a `DraggableModelItem` and add it to the board's items list.

```dart
final task = DraggableModelItem(
  id: Utils.generateRandomId(),
  title: 'New Task',
  description: 'Task description',
  priority: Priority.high,
  comment: [],
  startTime: DateTime.now(),
  endTime: DateTime.now().add(Duration(hours: 1)),
  createdAt: DateTime.now().toIso8601String(),
  category: 'Work',
  boardId: 'boardId1',
  tasks: [],
  peoples: [],
);

final board = boardRepository.getBoardById('boardId1');
if (board != null) {
  board.items.add(task);
  await boardRepository.updateBoard(board);
}
```

### Updating a Task

To update a task, use the `copyWith` method of `DraggableModelItem` and update the board.

```dart
final updatedTask = task.copyWith(
  title: 'Updated Task Title',
  description: 'Updated Task Description',
);

final board = boardRepository.getBoardById('boardId1');
if (board != null) {
  final index = board.items.indexWhere((item) => item.id == updatedTask.id);
  if (index != -1) {
    board.items[index] = updatedTask;
    await boardRepository.updateBoard(board);
  }
}
```

### Removing a Task

To remove a task from a board, update the board's items list and save the board.

```dart
final board = boardRepository.getBoardById('boardId1');
if (board != null) {
  board.items.removeWhere((item) => item.id == task.id);
  await boardRepository.updateBoard(board);
}
```

## Contributing

1. **Fork the repository**
2. **Create a new branch**

```bash
git checkout -b feature-branch
```

3. **Make your changes**
4. **Commit your changes**

```bash
git commit -m "Add some feature"
```

5. **Push to the branch**

```bash
git push origin feature-branch
```

6. **Open a pull request**

## License

This project is licensed under the MIT License.