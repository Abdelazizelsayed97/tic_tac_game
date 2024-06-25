import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;

  TimerCubit() : super(const TimerInitial([]));

  static TimerCubit get(BuildContext context) => BlocProvider.of<TimerCubit>(context);

  void startTimer({required List<int> remainingTimes}) {
    _timer?.cancel();
    emit(TimerRunInProgress(remainingTimes));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final updatedTimes = List<int>.from((state as TimerRunInProgress).remainingTimes);
      for (int i = 0; i < updatedTimes.length; i++) {
        if (updatedTimes[i] > 0) {
          updatedTimes[i]--;
        }
      }
      emit(TimerRunInProgress(updatedTimes));
      if (updatedTimes.every((time) => time == 0)) {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
