import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';

import '../state_management/tasks_cubit/tasks_cubit.dart';
import '../widgets/tic_toc_board_widget.dart';

class AssignedTabPage extends StatefulWidget {
  const AssignedTabPage({super.key});

  @override
  State<AssignedTabPage> createState() => _AssignedTabPageState();
}

class _AssignedTabPageState extends State<AssignedTabPage> {
  late Stream<int> _timerStream;
  late StreamController<int> _timerController;
  StreamSubscription<int>? _timerSubscription;

  @override
  void initState() {
    super.initState();
    _timerController = StreamController<int>();
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _timerController.close();
    super.dispose();
  }

  void _startTimer(int duration) {
    _timerStream =
        Stream.periodic(const Duration(seconds: 1), (x) => duration - x - 1)
            .take(duration);
    _timerSubscription = _timerStream.listen((duration) {
      _timerController.add(duration);
      if (mounted) {
        if (duration <= 0) {
          context.read<TasksCubit>().returnTaskToUnassigned();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        if (state.type == TasksStateType.taskAssignedSuccess) {
          _startTimer(state.assignedTimeout ?? 0);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Assigned Task: ${state.assignedTask}'),
              StreamBuilder<int>(
                stream: _timerController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Timeout: ${snapshot.data} seconds');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              verticalSpace(20),
              PlayScreen(
                removeFromList: state.assignedTask ?? 0,
              ),
            ],
          );
        }
        return const Center(
          child: Text("Unknown state"),
        );
      },
    );
  }
}
