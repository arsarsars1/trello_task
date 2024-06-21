import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:task_tracker_pro/model/color_adapter.dart';
import 'package:task_tracker_pro/model/comment_model.dart';
import 'package:task_tracker_pro/model/contact_adapter.dart';
import 'package:task_tracker_pro/model/datetime_adapter.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';
import 'package:task_tracker_pro/model/duration_adapter.dart';
import 'package:task_tracker_pro/model/priority.dart';
import 'package:task_tracker_pro/model/task_model.dart';
import 'package:task_tracker_pro/repositories/auth_repository.dart';
import 'package:task_tracker_pro/repositories/board_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(DraggableModelAdapter());
  Hive.registerAdapter(DraggableModelItemAdapter());
  Hive.registerAdapter(CommentModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(DateTimeAdapter());
  Hive.registerAdapter(DurationAdapter());

  await Hive.openBox<DraggableModel>('boards');
  await Hive.openBox('userBox');

  final boardBox = Hive.box<DraggableModel>('boards');
  getIt.registerSingleton(boardBox);

  final userBox = Hive.box('userBox');
  getIt.registerSingleton(userBox);

  getIt.registerLazySingleton(() => AuthRepository(userBox));
  getIt.registerLazySingleton(() => BoardRepository(boardBox));
}
