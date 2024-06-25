import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/ui/widgets/app_bar_widget.dart';
import 'package:tic_toc_game/utils/consts.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';

import '../../../utils/helpers/app_daimentions.dart';
import 'state_management/game_cubit/game_cubit.dart';
import 'state_management/tasks_cubit/tasks_cubit.dart';
import 'tabs/assgined_tab_page.dart';
import 'tabs/completed_tab_page.dart';
import 'tabs/unassgined_tasks_page.dart';
import 'widgets/tab_bar_widget.dart';

class MainTasksPage extends StatelessWidget {
  const MainTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(userMark: 'x'),
      child: const MainTasksBody(),
    );
  }
}

class MainTasksBody extends StatefulWidget {
  const MainTasksBody({super.key});

  @override
  State<MainTasksBody> createState() => _MainTasksBodyState();
}

class _MainTasksBodyState extends State<MainTasksBody> {
  @override
  void initState() {
    super.initState();
    _initializeTasks();
  }

  void _initializeTasks() {
    context.read<TasksCubit>().getTask();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Consts.tabsTitles.length,
      child: Scaffold(
        appBar: const AppBarWidget(),
        body: SafeArea(
          child: Padding(
            padding: AppDimensions.large(),
            child: Column(
              children: [
                const TabBarWidget(),
                verticalSpace(20),
                const Expanded(
                  child: TabBarView(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      UnassignedTabPage(),
                      AssignedTabPage(),
                      CompletedTabPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
