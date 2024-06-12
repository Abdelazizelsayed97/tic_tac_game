import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

class GetCompletedTasksUseCase{
  final TasksRepository _tasksRepository;
  GetCompletedTasksUseCase(this._tasksRepository);
CreateTasksEntity getCompletedTusks() => _tasksRepository.getCompletedTasks();
}