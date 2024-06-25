part of 'timer_cubit.dart';

abstract class TimerState {
  final List<int> remainingTimes;
  const TimerState(this.remainingTimes);
}

class TimerInitial extends TimerState {
  const TimerInitial(List<int> remainingTimes) : super(remainingTimes);
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(List<int> remainingTimes) : super(remainingTimes);
}
