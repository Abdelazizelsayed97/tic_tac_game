import 'package:equatable/equatable.dart';

class CreateTasksEntity extends Equatable {
  final String taskCount;
  final String sequence;

  const CreateTasksEntity({required this.taskCount, required this.sequence});

  @override
  List<Object> get props => [taskCount, sequence];
}
