import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/utils/consts.dart';

import '../state_management/tasks_cubit/tasks_cubit.dart';
import '../widgets/game_result_handler.dart';

class UnassignedTabPage extends StatefulWidget {
  const UnassignedTabPage({
    super.key,
  });

  @override
  State<UnassignedTabPage> createState() => _UnassignedTabPageState();
}

class _UnassignedTabPageState extends State<UnassignedTabPage> {
  List<int> _remainingTimes = [];
  List<Timer> _timers = [];
  GetTasksModel? getTasksModel;

  @override
  void initState() {
    super.initState();
    getTasksModel = TasksCubit.get(context).state.previewModel;
    _initializeTimers();
  }

  void _initializeTimers() {
    _remainingTimes = List.from(getTasksModel?.taskTimeout ?? []);
    _timers = List.generate(
      getTasksModel!.taskTimeout!.length,
      (index) {
        return Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            setState(
              () {
                if (_remainingTimes[index] > 0) {
                  _remainingTimes[index]--;
                } else if (_remainingTimes[index] == 0) {
                  timer.cancel();
                  context.read<TasksCubit>().deleteFromList(index);
                }
              },
            );
          },
        );
      },
    );
  }

  void _initializeTasks() {
    context.read<TasksCubit>().getTask();
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
    _assignTask(
        taskCount: getTasksModel?.taskCount?[index] ?? 0,
        sequence: _remainingTimes[index],
        index: index);
    ShowDialog.showErrorDialog(
      context: context,
      message: Consts.taskAssigned,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state.type == TasksStateType.taskAssignedSuccess) {
          DefaultTabController.of(context).animateTo(1);
        }
        if (state.type == TasksStateType.getTasksSuccess) {
          setState(() {
            _initializeTimers();
          });
        }
      },
      child: getTasksModel?.taskCount?.isNotEmpty == true
          ? ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Task ${getTasksModel?.taskCount?[index]}'),
                    trailing: Text(_formatTime(_remainingTimes[index])),
                    onTap: () => _onAssignTaskPressed(index),
                  ),
                );
              },
              itemCount: getTasksModel?.taskCount?.length,
            )
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  _initializeTasks();
                },
                child: const Text('Reload'),
              ),
            ),
    );
  }
}
