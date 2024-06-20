# Task Tracker Pro

Task Tracker Pro is a Flutter application designed to help you track and manage tasks efficiently. It allows users to create draggable boards with various task items, and supports priority settings, comments, tasks, and associated contacts for each item.

## Features

- Create and manage draggable boards.
- Add, update, and delete task items.
- Assign priorities to task items (High, Medium, Low).
- Add comments, tasks, and contacts to task items.
- Persist data using Hive for local storage.
- Authentication system to secure user access.

## Dependencies

- Flutter SDK
- Hive
- Hive Flutter
- Bloc
- GoRouter
- Path Provider

## Project Structure

```
lib/
│
├── bloc/
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   └── board/
│       ├── board_bloc.dart
│       ├── board_event.dart
│       └── board_state.dart
│
├── model/
│   ├── color_adapter.dart
│   ├── comment_model.dart
│   ├── contact.dart
│   ├── draggable_model.dart
│   ├── draggable_model_item.dart
│   ├── priority.dart
│   └── task_model.dart
│
├── repositories/
│   ├── auth_repository.dart
│   └── board_repository.dart
│
├── routes/
│   └── router.dart
│
├── screens/
│   ├── add_task_screen.dart
│   ├── board_screen.dart
│   ├── login_screen.dart
│   └── task_screen.dart
│
└── utils/
│   ├── utils.dart
│   └── extension.dart
│
├── widgets/
│   ├── add_item_widget.dart
│   ├── board_widget.dart
│   ├── custom_text_form_field.dart
│   ├── edit_item_widget.dart
│   └── pop_widget.dart
├── injection_controller.dart
├── main.dart
└── todo_api.dart
```

## Setup Instructions

### Prerequisites

Ensure you have the following installed:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: [Install Dart](https://dart.dev/get-dart)
- A suitable IDE (e.g., VSCode, Android Studio)

### Steps

1. **Clone the repository**

```bash
git clone https://github.com/your-repo/task_tracker_pro.git
cd task_tracker_pro
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Running `build_runner`**

To do a one-time build:
```dart
flutter pub run build_runner build
```

4. **Run the application**

```bash
flutter run
```

## Usage

### Authentication

- **Login:** The `LoginScreen` allows users to log in. On successful authentication, users are redirected to the board screen.
- **Redirect on Reopen:** The application checks if the user is authenticated on reopen and redirects accordingly.

### Boards and Items

- **Create a Board:** Users can create new boards and add task items to them.
- **Update a Board:** Boards and their items can be updated.
- **Delete a Board Item:** Task items can be removed from a board.
- **Priority Colors:** Task items are color-coded based on their priority using the `getPriorityColor` function.

## Functions

### Board Repository

- **Get All Boards:**
  ```dart
  List<DraggableModel> getBoards()
  ```

- **Add Board:**
  ```dart
  Future<void> addBoard(DraggableModel board)
  ```

- **Update Board:**
  ```dart
  Future<void> updateBoard(DraggableModel board)
  ```

- **Remove Board Item:**
  ```dart
  Future<void> removeBoardItem(DraggableModel boardModel)
  ```

- **Get Board by ID:**
  ```dart
  DraggableModel? getBoardById(String header)
  ```

- **Check if Data Exists:**
  ```dart
  bool isDataExist()
  ```

- **Update Boards:**
  ```dart
  Future<void> updateBoards(List<DraggableModel> boards)
  ```

### Priority Colors

- **Get Priority Color:**
  ```dart
  Color getPriorityColor(Priority priority)
  ```

## Troubleshooting

### Common Issues

- **Generate Models:** Ensure that you run the `flutter pub run build_runner build` command in the terminal to generate the model.


### Error Logs

Check the console output for detailed error logs if something goes wrong.