import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';

import '../widgets/tic_toc_board_widget.dart';

class AssignedTabPage extends StatelessWidget {
  const AssignedTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('This is the AssignedTabPage');
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        if (state is TaskAssignedSuccess) {
          return Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Assigned Task: ${state.assignedTask}'),
                Text('Timeout: ${state.assignedTimeout} seconds'),
                verticalSpace(20),
                 PlayScreen(removeFormList: state.assignedTask,)
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('No task assigned'),
          );
        }
      },
    );
  }
}
