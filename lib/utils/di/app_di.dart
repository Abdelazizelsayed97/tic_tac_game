import 'package:get_it/get_it.dart';
import 'package:tic_toc_game/features/tic_toc/data/repository/tasks_impl.dart';
import 'package:tic_toc_game/features/tic_toc/domain/repository/tasks_repository.dart';
import 'package:tic_toc_game/features/tic_toc/domain/use_case/add_tasks_use_case.dart';
import 'package:tic_toc_game/features/tic_toc/domain/use_case/completed_tasks_use_case.dart';
import 'package:tic_toc_game/features/tic_toc/domain/use_case/get_completed_tasks_use_case.dart';
import 'package:tic_toc_game/features/tic_toc/domain/use_case/get_tasks_use_case.dart';

import '../../features/tic_toc/domain/use_case/assign_task_use_case.dart';
import '../../features/tic_toc/ui/state_management/tasks_cubit/tasks_cubit.dart';

final injector = GetIt.instance;

class AppDi {
  static Future<void> initializeDi() async {
    injector.registerLazySingleton<TasksRepository>(() => TaskRepositoryImpl());
    injector.registerLazySingleton(() => AddTasksUseCase(injector()));
    injector.registerLazySingleton(() => GetTasksUseCase(injector()));
    injector.registerLazySingleton(() => AssignTaskUseCase(injector()));
    injector.registerLazySingleton(() => CompletedTasksUseCase(injector()));
    injector.registerLazySingleton(() => GetCompletedTasksUseCase(injector()));
    injector.registerLazySingleton(() =>
        TasksCubit(injector(), injector(), injector(), injector(), injector()));
  }
}
