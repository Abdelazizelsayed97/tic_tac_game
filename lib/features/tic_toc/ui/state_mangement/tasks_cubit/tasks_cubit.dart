import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  TasksCubit(this._addTasksUseCase, this._getTasksUseCase,
      this._assignTasksUseCase, this._completedTasksUseCase, this._getCompleted)
      : super(TasksInitial());

  static TasksCubit get(BuildContext context) => BlocProvider.of(context);

  void setTask({required CreateTasksEntity input}) {
    emit(TasksLoading());
    try {
      _addTasksUseCase.addTask(input);
      emit(TaskSetSuccess());
    } catch (e) {
      emit(TaskFailed(message: ErrorHandler.failedToCreateTask));
    }
  }


  void deleteFromList(int index) {
    taskList.removeAt(index);
    _timePerSecondList.removeAt(index);
  }

  void getTask() {
    final response = _getTasksUseCase.getTasks();
    print('response:  ' + "$response");
      print('result:  ' + "$response");
      const int defaultTime = 300;
      int minToSecond(int time) {
        final timePerSecond = time * 60;
        return timePerSecond;
      }

      void addTasksToList(int count) {
        taskList.clear();
        for (int i = 1; i <= count; i++) {
          taskList.add(i);
        }
      }

      void addTimeToList(int sequence) {
        _timePerSecondList.clear();
        for (int i = 0; i <= sequence; i++) {
          final x = defaultTime + minToSecond(sequence * i);
          _timePerSecondList.add(x);
        }
      }

      try {
        emit(TasksLoading());
        final int taskCount = int.parse(response.taskCount);
        final int sequence = int.parse(response.sequence ?? '');

        addTasksToList(taskCount);
        addTimeToList(sequence);

        emit(
          GetTasksSuccess(
            previewModel: GetTasksModel(
                taskCount: taskList, taskTimeout: _timePerSecondList),
          ),
        );
      } catch (e) {
        emit(const TaskFailed(message: ErrorHandler.failedToRetrieveTask));
      }

  }


  void assignTask({required int taskCount, required int sequence}) {
    emit(TasksLoading());
    try {
      final result = _assignTasksUseCase.assignTask(
        GetTasksModel(taskTimeout: _timePerSecondList, taskCount: taskList),
      );
      emit(
        TaskAssignedSuccess(
          assignedTask: taskCount,
          assignedTimeout: sequence,
          previewModel: GetTasksModel(
              taskTimeout: _timePerSecondList, taskCount: taskList),
        ),
      );
    } catch (e) {
      emit(const TaskFailed(message: ErrorHandler.failedToAssignTask));
    }
  }

  void completeTaskSuccess() {

      try {
        final oldState = state as TaskAssignedSuccess;
        _completedTasksUseCase.setCompletedTask(
          CreateTasksEntity(
            taskCount: oldState.assignedTask.toString(),
            sequence: '',
          ),
        );
        print('this is completed func');
        emit(
          TaskCompleted(
              assignedTask: oldState.assignedTask,
              previewModel: oldState.previewModel),
        );
      } catch (e) {
        emit(
          const TaskFailed(message: ErrorHandler.failedToCompleteTask),
        );
      }

  }

  void fetchCompletedTasks() {
    try {
      final oldState = state as TaskCompleted;
      final response = _getCompleted.getCompletedTusks();
      emit(
        GetCompletedTasksSuccess(response, oldState.previewModel),
      );
    } catch (e) {
      emit(
        const TaskFailed(message: ErrorHandler.failedToRetrieveTask),
      );
    }
  }
}
