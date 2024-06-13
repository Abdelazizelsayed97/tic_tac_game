import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/features/tic_toc/ui/widgets/game_result_handler.dart';
import 'package:tic_toc_game/utils/consts.dart';

class UnassignedTabPage extends StatefulWidget {
  final GetTasksModel getTasksModel;

  const UnassignedTabPage({
    super.key,
    required this.getTasksModel,
  });

  @override
  State<UnassignedTabPage> createState() => _UnassignedTabPageState();
}

class _UnassignedTabPageState extends State<UnassignedTabPage> {
  List<int> _remainingTimes = [];
  List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _initializeTimers();
  }

  void _initializeTimers() {
    _remainingTimes = List.from(widget.getTasksModel.taskTimeout ?? []);
    _timers = List.generate(
      widget.getTasksModel.taskTimeout!.length,
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

  void _assignTask({required int taskCount, required int sequence}) {
    context
        .read<TasksCubit>()
        .assignTask(sequence: sequence, taskCount: taskCount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TaskAssignedSuccess) {
          DefaultTabController.of(context).animateTo(1);
        }
        if (state is GetTasksSuccess) {
          setState(() {
            _initializeTimers();
          });
        }
      },
      child: widget.getTasksModel.taskCount?.isNotEmpty == true
          ? ListView.builder(
        itemBuilder: (context, index) {
        final data= widget.getTasksModel;
        final checkList= context.read<TasksCubit>().taskList;
          return Card(
            child: ListTile(
              title: Text('Task ${data.taskCount?[index]}'),
              trailing: Text(_formatTime(_remainingTimes[index])),
              onTap: () {
                 _assignTask(
                    taskCount: data.taskCount?[index] ?? 0,
                    sequence: _remainingTimes[index]);
                ShowDialog.showErrorDialog(
                  context: context,
                  message: Consts.taskAssigned,
                );
                // context.read<TasksCubit>().deleteFromList(index);
              },
            ),
          );
        },
        itemCount: widget.getTasksModel.taskCount?.length,
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
