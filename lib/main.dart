import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/utils/colors/app_colors.dart';
import 'package:tic_toc_game/utils/di/app_di.dart';

import 'features/tic_toc/ui/set_tasks_screen.dart';

void main() {
  runApp(TicTacGame());
  WidgetsFlutterBinding.ensureInitialized();
  AppDi.initializeDi();
}

class TicTacGame extends StatelessWidget {
  TicTacGame({super.key});

  final ThemeData _theme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: ColorsManger.praimaryColor(),
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsManger.praimaryColor(),
      ));

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: BlocProvider(
        create: (context) => TasksCubit(
            injector(), injector(), injector(), injector(), injector()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _theme,
          home: const SetTasksScreen(),
        ),
      ),
    );
  }
}
