import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

class TaskRepositoryImpl implements TasksRepository {
  String _taskCount = '';
  String _sequence = '';
  List<int> _taskList = [];
  List<int> _taskTimeouts = [];
  List<CreateTasksEntity> completedTasksList = [];

  @override
  void setTasks(CreateTasksEntity input) {
    _taskCount = input.taskCount;
    _sequence = input.taskCount;
  }
  @override
  CreateTasksEntity getTasks() {
    return CreateTasksEntity(taskCount: _taskCount, sequence: _sequence);
  }


  @override
  void assignTasks(GetTasksModel input) {}

  @override
  void addedCompletedTasks(CreateTasksEntity input) {
    completedTasksList.add(input);
  }

  @override
  List<CreateTasksEntity> getCompletedTasks() {
    return completedTasksList;
  }
}
