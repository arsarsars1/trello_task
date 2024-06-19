import 'package:go_router/go_router.dart';
import 'package:task_tracker_pro/screen/add_task_screen.dart';
import 'package:task_tracker_pro/screen/board_screen.dart';
import 'package:task_tracker_pro/screen/login_screen.dart';
import 'package:task_tracker_pro/screen/task_screen.dart';

class AppRouter {
  final GoRouter _router;

  AppRouter()
      : _router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => LoginScreen(),
            ),
            GoRoute(
              path: '/board',
              builder: (context, state) => const BoardScreen(),
            ),
            GoRoute(
              path: '/task',
              builder: (context, state) => const TaskScreen(),
            ),
            GoRoute(
              path: '/dragForm',
              builder: (context, state) => DraggableItemForm(),
            ),
          ],
        );

  GoRouter get router => _router;
}
