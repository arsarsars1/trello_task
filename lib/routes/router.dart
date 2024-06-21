import 'package:go_router/go_router.dart';
import 'package:task_tracker_pro/screen/add_task_screen.dart';
import 'package:task_tracker_pro/screen/board_screen.dart';
import 'package:task_tracker_pro/screen/login_screen.dart';

class AppRouter {
  final GoRouter _router;

  AppRouter()
      : _router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: '/board',
              builder: (context, state) => const BoardScreen(),
            ),
            GoRoute(
              path: '/dragForm',
              builder: (context, state) => const DraggableItemForm(),
            ),
          ],
        );

  GoRouter get router => _router;
}
