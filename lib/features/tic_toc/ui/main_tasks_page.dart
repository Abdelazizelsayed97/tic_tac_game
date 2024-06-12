import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/game_cubit/game_cubit.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/features/tic_toc/ui/widgets/app_bar_widget.dart';
import 'package:tic_toc_game/utils/consts.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';

import '../../../utils/helpers/app_daimentions.dart';
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
      child: MainTasksBody(),
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

  _stateChanges(TasksState newState) {
    if (newState is TaskAssigned) {
      return newState as TaskAssigned;
    } else {
      return newState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Consts.tabsTitles.length,
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is TaskRetrieved ||
              state is TaskAssigned ||
              state is TaskCompleted) {
            return Scaffold(
              appBar: const AppBarWidget(),
              body: SafeArea(
                child: Padding(
                  padding: AppDimensions.large(),
                  child: Column(
                    children: [
                      const TabBarWidget(),
                      verticalSpace(20),
                      Expanded(
                        child: TabBarView(
                          clipBehavior: Clip.antiAlias,
                          children: [
                            UnassignedTabPage(
                              getTasksModel: _stateChanges(state).previewModel,
                            ),
                            const AssignedTabPage(),
                            const CompletedTabPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is TasksLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Text("Error in main page"),
            ),
          );
        },
      ),
    );
  }
}
