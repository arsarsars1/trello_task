import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_pro/bloc/auth/auth_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_bloc.dart';
import 'package:task_tracker_pro/injection_container.dart';
import 'package:task_tracker_pro/repositories/auth_repository.dart';
import 'package:task_tracker_pro/repositories/board_repository.dart';

import 'injection_container.dart' as di;
import 'routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(getIt<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) => BoardBloc(getIt<BoardRepository>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.router.routerDelegate,
        routeInformationParser: appRouter.router.routeInformationParser,
        routeInformationProvider: appRouter.router.routeInformationProvider,
      ),
    );
  }
}
