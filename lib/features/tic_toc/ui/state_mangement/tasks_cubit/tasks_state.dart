part of 'tasks_cubit.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TaskSetSuccess extends TasksState {
  @override
  List<Object> get props => [];
}

class GetTasksSuccess extends TasksState {
  final GetTasksModel previewModel;

  const GetTasksSuccess({required this.previewModel});

  GetTasksSuccess copyWith({
    GetTasksModel? previewModel,
  }) {
    return GetTasksSuccess(
      previewModel: previewModel ?? this.previewModel,
    );
  }

  @override
  List<Object> get props => [previewModel];
}

class GetCompletedTasksSuccess extends TasksState {
  final List<CreateTasksEntity> previewEntity;
  final GetTasksModel previewModel;

  const GetCompletedTasksSuccess(this.previewEntity, this.previewModel);
}

class TaskAssignedSuccess extends TasksState {
  final int assignedTask;
  final int assignedTimeout;
  final GetTasksModel previewModel;

  const TaskAssignedSuccess({
    required this.assignedTask,
    required this.assignedTimeout,
    required this.previewModel,
  });

  TaskAssignedSuccess copyWith({
    int? assignedTask,
    int? assignedTimeout,
    GetTasksModel? previewModel,
  }) {
    return TaskAssignedSuccess(
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

  const TaskCompleted({this.assignedTask, required this.previewModel});

  @override
  List<Object> get props => [previewModel];
}

class TaskFailed extends TasksState {
  final String message;

  const TaskFailed({required this.message});

  @override
  List<Object> get props => [message];
}
