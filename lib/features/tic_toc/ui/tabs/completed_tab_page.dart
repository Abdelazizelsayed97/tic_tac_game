import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';

import '../state_management/tasks_cubit/tasks_cubit.dart';

class CompletedTabPage extends StatefulWidget {
  const CompletedTabPage({super.key});

  @override
  State<CompletedTabPage> createState() => _CompletedTabPageState();
}

class _CompletedTabPageState extends State<CompletedTabPage> {
  List<CreateTasksEntity>? taskEntity = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
      taskEntity = state.previewCompletedTasks;
      print('taskEntity: ${taskEntity?.length}');
      return ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title:
                  Text("Task ${taskEntity?[index].taskCount} is 😆 completed"),
            ),
          );
        },
        itemCount: taskEntity?.length ?? 0,
      );
    });
  }
}
