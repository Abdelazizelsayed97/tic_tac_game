import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';

import '../entity/create_tasks_entity.dart';

class AssignTaskUseCase{
  final TasksRepository _tasksRepository;

  AssignTaskUseCase(this._tasksRepository);
  void assignTask(GetTasksModel model)  {
     _tasksRepository.assignTasks(model);
  }
}