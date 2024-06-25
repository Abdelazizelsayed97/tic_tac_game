import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/domain/use_case/get_completed_tasks_use_case.dart';
import 'package:tic_toc_game/utils/error_handler/error_handler.dart';

import '../../../data/model/get_tasks_model.dart';
import '../../../domain/use_case/add_tasks_use_case.dart';
import '../../../domain/use_case/assign_task_use_case.dart';
import '../../../domain/use_case/completed_tasks_use_case.dart';
import '../../../domain/use_case/get_tasks_use_case.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final AddTasksUseCase _addTasksUseCase;
  final GetTasksUseCase _getTasksUseCase;
  final AssignTaskUseCase _assignTasksUseCase;
  final CompletedTasksUseCase _completedTasksUseCase;
  final GetCompletedTasksUseCase _getCompleted;
  final List<int> taskList = [];
  final List<int> _timePerSecondList = [];
  DateTime? _startTime;

  TasksCubit(this._addTasksUseCase, this._getTasksUseCase,
      this._assignTasksUseCase, this._completedTasksUseCase, this._getCompleted)
      : super(const TasksState.initial());

  static TasksCubit get(BuildContext context) => BlocProvider.of(context);

  void setTask({required CreateTasksEntity input}) {
    emit(state.copyWith(type: TasksStateType.loading));
    try {
      _addTasksUseCase.addTask(input);
      emit(state.copyWith(type: TasksStateType.taskSetSuccess));
    } catch (e) {
      emit(state.copyWith(
          type: TasksStateType.taskFailed,
          message: ErrorHandler.failedToCreateTask));
    }
  }

  void _updateTimeScaling(int elapsed) {
    final updatedTimeouts = List<int>.from(state.previewModel!.taskTimeout!);

    for (int i = 0; i < updatedTimeouts.length; i++) {
      if (updatedTimeouts[i] > 0) {
        updatedTimeouts[i] = updatedTimeouts[i] > elapsed ? updatedTimeouts[i] - elapsed : 0;
      }
    }

    emit(state.copyWith(
      previewModel: state.previewModel!.copyWith(taskTimeout: updatedTimeouts),
    ));

    // Reset the start time after updating to ensure accurate timing on the next tick
    _startTime = DateTime.now();
  }

  void deleteFromList(int index) {
    taskList.removeWhere(
      (element) => element == state.assignedTask,
    );
    _timePerSecondList.removeWhere(
      (element) => element == state.assignedTimeout,
    );
  }

  void getTask() {
    final response = _getTasksUseCase.getTasks();
    void addTasksToList(int count) {
      taskList.clear();
      for (int i = 1; i <= count; i++) {
        taskList.add(i);
      }
    }

    void addTimeToList(int sequence) {
      _timePerSecondList.clear();
      for (int i = 1; i <= taskList.length; i++) {
        var x = sequence * i;

        _timePerSecondList.add(
          x * 60,
        );
      }
    }

    try {
      emit(state.copyWith(type: TasksStateType.loading));

      final int taskCount = int.parse(response.taskCount);
      final int sequence = int.parse(response.sequence ?? '');
      print('sequence result ${sequence}');

      addTasksToList(taskCount);
      addTimeToList(sequence);

      emit(
        state.copyWith(
          type: TasksStateType.getTasksSuccess,
          previewModel: GetTasksModel(
            taskCount: taskList,
            taskTimeout: _timePerSecondList,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          type: TasksStateType.taskFailed,
          message: ErrorHandler.failedToRetrieveTask));
    }
  }

  void assignTask({int? taskCount, int? sequence}) {
    emit(state.copyWith(type: TasksStateType.loading));
    try {
      final result = _assignTasksUseCase.assignTask(
        GetTasksModel(taskTimeout: _timePerSecondList, taskCount: taskList),
      );
      if (sequence == 0) {
        emit(const TasksState.initial());
      } else {
        emit(
          state.copyWith(
            type: TasksStateType.taskAssignedSuccess,
            assignedTask: taskCount,
            assignedTimeout: sequence,
            previewModel: GetTasksModel(
              taskTimeout: _timePerSecondList,
              taskCount: taskList,
            ),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          type: TasksStateType.taskFailed,
          message: ErrorHandler.failedToAssignTask));
    }
  }

  void completeTaskSuccess() async {
    try {
      if (state.type == TasksStateType.taskAssignedSuccess) {
        _completedTasksUseCase.setCompletedTask(
          CreateTasksEntity(
            taskCount: state.assignedTask.toString(),
            sequence: '',
          ),
        );
        emit(
          state.copyWith(
            type: TasksStateType.taskCompleted,
            previewModel: state.previewModel!,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          type: TasksStateType.taskFailed,
          message: ErrorHandler.failedToCompleteTask));
    }
  }

  void fetchCompletedTasks() {
    try {
      final response = _getCompleted.getCompletedTusks();

      emit(
        state.copyWith(
          type: TasksStateType.getCompletedTasksSuccess,
          previewCompletedTasks: response,
          previewModel: state.previewModel!,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            type: TasksStateType.taskFailed,
            message: ErrorHandler.failedToRetrieveTask),
      );
    }
  }

  void returnTaskToUnassigned() {
    final task = state.assignedTask;
    if (task != null) {
      taskList.add(task);
      _timePerSecondList.add(state.assignedTimeout ?? 0);
      emit(
        state.copyWith(
          type: TasksStateType.getTasksSuccess,
          previewModel: GetTasksModel(
            taskCount: taskList,
            taskTimeout: _timePerSecondList,
          ),
        ),
      );
    }
  }
}
