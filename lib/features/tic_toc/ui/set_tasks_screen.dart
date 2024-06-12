import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/ui/main_tasks_page.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/features/tic_toc/ui/widgets/app_bar_widget.dart';
import 'package:tic_toc_game/features/tic_toc/ui/widgets/defined_task_and_duration_widget.dart';
import 'package:tic_toc_game/utils/helpers/app_daimentions.dart';

class SetTasksScreen extends StatefulWidget {
  const SetTasksScreen({super.key});

  @override
  State<SetTasksScreen> createState() => _SetTasksScreenState();
}

class _SetTasksScreenState extends State<SetTasksScreen> {
  final _taskCount = TextEditingController();
  final _sequence = TextEditingController();

  void setTaskInput(CreateTasksEntity input) {
    context.read<TasksCubit>().setTask(
        input: CreateTasksEntity(
            taskCount: input.taskCount, sequence: input.sequence));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TaskSet) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainTasksPage(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const AppBarWidget(),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: AppDimensions.large(),
          child: DefinedTaskAndDurationWidget(
            taskCount: _taskCount,
            sequence: _sequence,
            onTap: () {
              setTaskInput(CreateTasksEntity(
                  taskCount: _taskCount.text, sequence: _sequence.text));
            },
          ),
        ),
      ),
    );
  }
}
