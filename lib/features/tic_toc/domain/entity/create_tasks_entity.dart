import 'package:equatable/equatable.dart';

class CreateTasksEntity extends Equatable {
  final String taskCount;
  final String? sequence;

  const CreateTasksEntity({
    required this.taskCount,
    this.sequence,
  });

  @override
  List<Object> get props => [
        taskCount
      ];
}
