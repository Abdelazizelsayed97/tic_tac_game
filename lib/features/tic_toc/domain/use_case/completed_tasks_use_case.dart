import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/domain/entity/create_tasks_entity.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

class CompletedTasksUseCase{
  final TasksRepository _tasksRepository;

  CompletedTasksUseCase(this._tasksRepository);
  void setCompletedTask(CreateTasksEntity input){
    _tasksRepository.addedCompletedTasks(input);
  }
}