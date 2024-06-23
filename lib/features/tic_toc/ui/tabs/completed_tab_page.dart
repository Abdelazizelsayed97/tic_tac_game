import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';

class CompletedTabPage extends StatefulWidget {
  const CompletedTabPage({super.key});

  @override
  State<CompletedTabPage> createState() => _CompletedTabPageState();
}

class _CompletedTabPageState extends State<CompletedTabPage> {
  List<CreateTasksEntity>? taskEntity = [];


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        if (state is GetCompletedTasksSuccess) {
          taskEntity = state.previewEntity;

          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                      "Task ${taskEntity?[index].taskCount} is 😆 completed"),
                ),
              );
            },
            itemCount: taskEntity?.length,
          );
        } else {
          return const Center(
            child: Text("No tasks completed"),
          );
        }
      },
    );
  }
}
