part of 'tasks_cubit.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TaskSet extends TasksState {
  @override
  List<Object> get props => [];
}

class TaskRetrieved extends TasksState {
  final GetTasksModel previewModel;

  const TaskRetrieved({required this.previewModel});

  TaskRetrieved copyWith({
    GetTasksModel? previewModel,
  }) {
    return TaskRetrieved(
      previewModel: previewModel ?? this.previewModel,
    );
  }

  @override
  List<Object> get props => [previewModel];
}


class TaskAssigned extends TasksState {
  final int assignedTask;
  final int assignedTimeout;
  final GetTasksModel previewModel;

  const TaskAssigned({
    required this.assignedTask,
    required this.assignedTimeout,
    required this.previewModel,
  });

  TaskAssigned copyWith({
    int? assignedTask,
    int? assignedTimeout,
    GetTasksModel? previewModel,
  }) {
    return TaskAssigned(
      assignedTask: assignedTask ?? this.assignedTask,
      assignedTimeout: assignedTimeout ?? this.assignedTimeout,
      previewModel: previewModel ?? this.previewModel,
    );
  }

  @override
  List<Object> get props => [assignedTask, assignedTimeout, previewModel];
}

class TaskCompleted extends TasksState {
  final int? assignedTask;
  final GetTasksModel previewModel;

  const TaskCompleted({ this.assignedTask, required this.previewModel});

  @override
  List<Object> get props => [previewModel];
}

class TaskFailed extends TasksState {
  final String message;

  const TaskFailed({required this.message});

  @override
  List<Object> get props => [message];
}