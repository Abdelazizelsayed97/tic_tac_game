
import 'package:tic_toc_game/features/tic_toc/data/model/get_tasks_model.dart';

import '../entity/create_tasks_entity.dart';

abstract class TasksRepository{
  void setTasks(CreateTasksEntity input);
  CreateTasksEntity getTasks();
 void assignTasks(GetTasksModel input);
  void setCompletedTasks(CreateTasksEntity input);
  CreateTasksEntity getCompletedTasks();
}