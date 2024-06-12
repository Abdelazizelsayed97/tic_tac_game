import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';

class CompletedTabPage extends StatefulWidget {
  const CompletedTabPage({super.key});

  @override
  State<CompletedTabPage> createState() => _CompletedTabPageState();
}

class _CompletedTabPageState extends State<CompletedTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: BlocBuilder<TasksCubit, TasksState>(

        builder: (context, state) {
          if (state is TaskCompleted) {

            return Column(children: [
              Text("Task${state.assignedTask.toString()}")
            ],);
          }else{
            return const Center(child: Text("No tasks completed"),);
          }

        },
      ),
    );
  }
}
