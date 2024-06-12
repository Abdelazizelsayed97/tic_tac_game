import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

import '../entity/create_tasks_entity.dart';

class GetTasksUseCase {
  final TasksRepository _tasksRepository;

  GetTasksUseCase(this._tasksRepository);

  CreateTasksEntity getTasks() {
    return _tasksRepository.getTasks();
  }
}
