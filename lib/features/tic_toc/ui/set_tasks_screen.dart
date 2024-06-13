import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/ui/main_tasks_page.dart';
import 'package:tic_toc_game/features/tic_toc/ui/state_mangement/tasks_cubit/tasks_cubit.dart';
import 'package:tic_toc_game/features/tic_toc/ui/widgets/app_bar_widget.dart';
import 'package:tic_toc_game/utils/app_button/app_button.dart';
import 'package:tic_toc_game/utils/app_text_field/app_text_field.dart';
import 'package:tic_toc_game/utils/colors/app_colors.dart';
import 'package:tic_toc_game/utils/consts.dart';
import 'package:tic_toc_game/utils/helpers/app_daimentions.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';
import 'package:tic_toc_game/utils/text_styles/text_styles.dart';

class SetTasksScreen extends StatefulWidget {
  const SetTasksScreen({super.key});

  @override
  State<SetTasksScreen> createState() => _SetTasksScreenState();
}

class _SetTasksScreenState extends State<SetTasksScreen> {
  final _numberOfTaskController = TextEditingController();
  final _sequenceOfTaskController = TextEditingController();
  final GlobalKey _formKey = GlobalKey();

  bool _isFilled() {
    if ((_numberOfTaskController.text.isNotEmpty) &&
        (_sequenceOfTaskController.text.isNotEmpty)
       ) {
      return true;
    } else {
      return false;
    }
  }

  bool validateCreateTasks() {
    final int taskCount = int.parse(_numberOfTaskController.text);
    final int sequenceCount = int.parse(_sequenceOfTaskController.text);
    if (taskCount <= sequenceCount) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    _numberOfTaskController.dispose();
    _sequenceOfTaskController.dispose();
    super.dispose();
  }

  void _onGoPress() {

    if (_isFilled()==true) {
      context.read<TasksCubit>().setTask(
            input: CreateTasksEntity(
              taskCount: _numberOfTaskController.text.trim(),
              sequence: _sequenceOfTaskController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TaskSetSuccess) {
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                verticalSpace(50),
                AppTextField(
                  controller: _numberOfTaskController,
                  label: Consts.numberTaskField,
                  onChanged: (text) {
                    _isFilled();
                    setState(() {});
                  },
                ),
                verticalSpace(20),
                AppTextField(
                  controller: _sequenceOfTaskController,
                  label: Consts.sequenceTaskField,
                  onChanged: (p0) {
                    _isFilled();
                    setState(() {});
                  },
                ),
                verticalSpace(30),
                AppButton(
                  color: (_isFilled())
                      ? ColorsManger.praimaryColor()
                      : Colors.grey.shade200,
                  onTap: _onGoPress,
                  height: Consts.mainProprityHeight,
                  child: Text(
                    "Goo",
                    style: Styles.bold(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
