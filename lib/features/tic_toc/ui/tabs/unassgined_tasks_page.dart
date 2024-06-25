import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_management/timer/timer_cubit.dart';

import '../state_management/tasks_cubit/tasks_cubit.dart';

class UnassignedTabPage extends StatefulWidget {
  const UnassignedTabPage({
    super.key,
  });

  @override
  State<UnassignedTabPage> createState() => _UnassignedTabPageState();
}

class _UnassignedTabPageState extends State<UnassignedTabPage> {
  GetTasksModel? getTasksModel;

  @override
  void initState() {
    getTasksModel = TasksCubit.get(context).state.previewModel;
    super.initState();
  }

  void _fetchTaskByCount() {
    context.read<TasksCubit>().getTask();
  }

  void _assignTask(
      {required int taskCount, required int sequence, required int index}) {
    context
        .read<TasksCubit>()
        .assignTask(sequence: sequence, taskCount: taskCount);
    context.read<TasksCubit>().deleteFromList(index);
    DefaultTabController.of(context).animateTo(1);
  }

  void _onAssignTaskPressed(int index) {
    // _assignTask(
    //     taskCount: getTasksModel?.taskCount?[index] ?? 0,
    //     sequence: _remainingTimes[index],
    //     index: index);
    // ShowDialog.showErrorDialog(
    //   context: context,
    //   message: Consts.taskAssigned,
    // );
  }

//    final taskCount = int.tryParse(entity?.taskCount ?? '') ?? 0;
//     final timeout = int.tryParse(entity?.sequence ?? '') ?? 0;
//     taskTimerList = List.generate(
//       taskCount,
//       (index) => TaskTimer(
//         timeout: timeout * (index + 1),
//       ),
//     );


  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state.type == TasksStateType.taskAssignedSuccess) {
          DefaultTabController.of(context).animateTo(1);
        }
      },
      child: BlocBuilder<TimerCubit, TimerState>(
        builder: (context, state) {
          final minutes =
              state.remainingTimes.map((time) => time ~/ 60).toList();
          final seconds =
              state.remainingTimes.map((time) => time % 60).toList();
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('Task ${index + 1}'),
                  trailing: Text(
                      '${minutes[index].toString().padLeft(2, '0')}:${seconds[index].toString().padLeft(2, '0')}'),
                  onTap: () => _onAssignTaskPressed(index),
                ),
              );
            },
            itemCount: (getTasksModel?.taskCount?.length),
          );
        },
      ),
    );
  }
}
