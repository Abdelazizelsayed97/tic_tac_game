import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  final List<int> _taskList = [];
  final List<int> _timePerSecondList = [];

  TasksCubit(this._addTasksUseCase, this._getTasksUseCase,
      this._assignTasksUseCase, this._completedTasksUseCase, this._getCompleted)
      : super(TasksInitial());

  void setTask({required CreateTasksEntity input}) {
    emit(TasksLoading());
    try {
      final request = _addTasksUseCase.addTask(input);
      emit(TaskSet());
      print('success');
    } catch (e) {
      emit(TaskFailed(message: ErrorHandler.failedToCreateTask));
    }
  }

  void deleteFromList(int index) {
    _taskList.removeAt(index);
    _timePerSecondList.removeAt(index);
  }

  void getTask() {
    final response = _getTasksUseCase.getTasks();
    if (state is TaskSet) {
      const int defaultTime = 300;

      void addTasksToList(int count) {
        _taskList.clear();
        for (int i = 1; i <= count; i++) {
          _taskList.add(i);
        }
      }

      void addTimeToList(int sequence) {
        _timePerSecondList.clear();
        for (int i = 1; i <= sequence; i++) {
          final x = defaultTime * i;
          _timePerSecondList.add(x);
        }
      }

      try {
        emit(TasksLoading());
        final int taskCount = int.parse(response.taskCount);
        final int sequence = int.parse(response.sequence);

        addTasksToList(taskCount);
        addTimeToList(sequence);

        emit(
          TaskRetrieved(
            previewModel: GetTasksModel(
                taskCount: _taskList, taskTimeout: _timePerSecondList),
          ),
        );
      } catch (e) {
        emit(const TaskFailed(message: ErrorHandler.failedToRetrieveTask));
      }
    } else {
      emit(const TaskFailed(message: ErrorHandler.noTaskSet));
    }
  }

  void assignTask({required int taskCount, required int sequence}) {
    // final oldState = state as TaskCompleted;
    emit(TasksLoading());
    try {
      final result = _assignTasksUseCase.assignTask(
          GetTasksModel(taskTimeout: _timePerSecondList, taskCount: _taskList));
      emit(TaskAssigned(
        assignedTask: taskCount,
        assignedTimeout: sequence,
        previewModel:
            GetTasksModel(taskTimeout: _timePerSecondList, taskCount: _taskList),
      ));
    } catch (e) {
      emit(const TaskFailed(message: ErrorHandler.failedToAssignTask));
    }
  }

  void completeTask() {
    if (state is TaskAssigned) {
      try {
        final oldState = state as TaskAssigned;
        _completedTasksUseCase.setCompletedTask(CreateTasksEntity(
            taskCount: oldState.assignedTask.toString(), sequence: ''));
        print('this is completed func');
        emit(TaskCompleted(
            assignedTask: oldState.assignedTask,
            previewModel: oldState.previewModel));
      } catch (e) {
        emit(const TaskFailed(message: ErrorHandler.failedToCompleteTask));
      }
    } else {
      emit(const TaskFailed(message: ErrorHandler.noTaskSet));
    }
  }
  void getCompletedTasks() {
    final response = _getCompleted.getCompletedTusks();
    if (state is TaskCompleted) {
      try {
        emit(TasksLoading());


        emit(
          TaskRetrieved(
            previewModel: GetTasksModel(
                taskCount: _taskList, taskTimeout: _timePerSecondList),
          ),
        );
      } catch (e) {
        emit(const TaskFailed(message: ErrorHandler.failedToRetrieveTask));
      }
    } else {
      emit(const TaskFailed(message: ErrorHandler.noTaskSet));
    }
  }
}
