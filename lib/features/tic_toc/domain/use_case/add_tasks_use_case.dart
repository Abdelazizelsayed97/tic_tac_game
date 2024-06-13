import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

class AddTasksUseCase {
  final TasksRepository _tasksRepository;

  AddTasksUseCase(this._tasksRepository);
  void addTask(CreateTasksEntity input) {
    _tasksRepository.setTasks(input);
  }
}
