import 'package:equatable/equatable.dart';

class GetTasksModel extends Equatable {
  final List<int>? taskCount;
  final List<int>? taskTimeout;

  const GetTasksModel({
    this.taskCount,
    this.taskTimeout,
  });

  GetTasksModel copyWith({
    List<int>? taskCount,
    List<int>? taskTimeout,
  }) {
    return GetTasksModel(
      taskCount: taskCount ?? this.taskCount,
      taskTimeout: taskTimeout ?? this.taskTimeout,
    );
  }

  @override
  List<Object?> get props => [
        taskCount,
        taskTimeout,
      ];
}
