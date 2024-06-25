class GetTasksModel {
  final List<int>? taskCount;
  final List<int>? taskTimeout;

  GetTasksModel({this.taskCount, this.taskTimeout});

  GetTasksModel copyWith({
    List<int>? taskCount,
    List<int>? taskTimeout,
  }) {
    return GetTasksModel(
      taskCount: taskCount ?? this.taskCount,
      taskTimeout: taskTimeout ?? this.taskTimeout,
    );
  }
}
