import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

class TasksImplRepository implements TasksRepository {
  String _taskCount = '';
  String _sequence = '';
  List<int> _taskList = [];
  List<int> _taskTimeouts = [];
  List<CreateTasksEntity> completedTasks = [];

  @override
  CreateTasksEntity getTasks() {
    return CreateTasksEntity(taskCount: _taskCount, sequence: _sequence);
  }

  @override
  void setTasks(CreateTasksEntity input) {
    _taskCount = input.taskCount;
    _sequence = input.taskCount;
  }

  @override
  void assignTasks(GetTasksModel input) {}

  @override
  void setCompletedTasks(CreateTasksEntity input) {
    completedTasks.add(input);
  }

  @override
  CreateTasksEntity getCompletedTasks() {
    return CreateTasksEntity(
        taskCount: completedTasks
            .map(
              (e) => e.taskCount,
            )
            .toString(),
        sequence: completedTasks
            .map(
              (e) => e.taskCount,
            )
            .toString());
  }
}
