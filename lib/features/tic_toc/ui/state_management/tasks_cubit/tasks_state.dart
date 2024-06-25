part of 'tasks_cubit.dart';

enum TasksStateType {
   initial,
  loading,
  taskSetSuccess,
  getTasksSuccess,
  getCompletedTasksSuccess,
  taskAssignedSuccess,
  taskCompleted,
  taskFailed,
}

class TasksState extends Equatable {
  final GetTasksModel? previewModel;
  final List<CreateTasksEntity>? previewCompletedTasks;
  final int? assignedTask;
  final int? assignedTimeout;
  final String? message;
  final TasksStateType type;

  const TasksState._({
    this.previewModel,
    this.previewCompletedTasks,
    this.assignedTask,
    this.assignedTimeout,
    this.message,
    required this.type,
  });

  const TasksState.initial() : this._(type: TasksStateType.initial);

  const TasksState.loading() : this._(type: TasksStateType.loading);

  const TasksState.taskSetSuccess()
      : this._(type: TasksStateType.taskSetSuccess);

  const TasksState.getTasksSuccess([GetTasksModel? previewModel])
      : this._(
            previewModel: previewModel, type: TasksStateType.getTasksSuccess);

  const TasksState.getCompletedTasksSuccess(
    List<CreateTasksEntity> previewCompletedTasks,
    GetTasksModel previewModel,
  ) : this._(
          previewCompletedTasks: previewCompletedTasks,
          previewModel: previewModel,
          type: TasksStateType.getCompletedTasksSuccess,
        );

  const TasksState.taskAssignedSuccess({
    int? assignedTask,
    int? assignedTimeout,
    GetTasksModel? previewModel,
  }) : this._(
          assignedTask: assignedTask,
          assignedTimeout: assignedTimeout,
          previewModel: previewModel,
          type: TasksStateType.taskAssignedSuccess,
        );

  const TasksState.taskCompleted({
    int? assignedTask,
    required GetTasksModel previewModel,
  }) : this._(
          assignedTask: assignedTask,
          previewModel: previewModel,
          type: TasksStateType.taskCompleted,
        );

  const TasksState.taskFailed({required String message})
      : this._(message: message, type: TasksStateType.taskFailed);

  @override
  List<Object?> get props => [
        previewModel,
        previewCompletedTasks,
        assignedTask,
        assignedTimeout,
        message,
        type,
      ];

  TasksState copyWith({
    GetTasksModel? previewModel,
    List<CreateTasksEntity>? previewCompletedTasks,
    int? assignedTask,
    int? assignedTimeout,
    String? message,
    TasksStateType? type,
  }) {
    return TasksState._(
      previewModel: previewModel ?? this.previewModel,
      previewCompletedTasks:
          previewCompletedTasks ?? this.previewCompletedTasks,
      assignedTask: assignedTask ?? this.assignedTask,
      assignedTimeout: assignedTimeout ?? this.assignedTimeout,
      message: message ?? this.message,
      type: type ?? this.type,
    );
  }
}
