import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';

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
  late List<int> _remainingTimes;
  late List<Timer> _timers;

  @override
  void initState() {
    super.initState();
    _remainingTimes = List.from(widget.getTasksModel.taskTimeout ?? []);
    _timers = List.generate(widget.getTasksModel.taskTimeout!.length, (index) {
      return Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTimes[index] > 0) {
            _remainingTimes[index]--;
          } else {
            timer.cancel();
          }
        });
      });
    });
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
        if (state is TaskAssigned) {
          DefaultTabController.of(context).animateTo(1);
        }
        print('State:>>>>$state');
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Task ${widget.getTasksModel.taskCount?[index]}'),
              trailing: Text(_formatTime(_remainingTimes[index])),
              onTap: () {
                int? timeValue =
                    int.tryParse(_formatTime(_remainingTimes[index]));
                _assignTask(

                    taskCount: widget.getTasksModel.taskCount?[index] ?? 0,
                    sequence: timeValue??0);
                // widget.getTasksModel.taskCount?.removeAt(index);
                context.read<TasksCubit>(). deleteFromList(index);

              },
            ),
          );
        },
        itemCount: widget.getTasksModel.taskCount?.length,
      ),
    );
  }
}
