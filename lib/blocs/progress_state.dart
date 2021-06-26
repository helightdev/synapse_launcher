part of 'progress_cubit.dart';

@immutable
abstract class ProgressState {
  bool active;
  double value;
  double max;

  double getPercent() {
    var result = value / max;
    if (result == double.infinity || result == double.nan || result == double.negativeInfinity) return 0;
    return result;
  }
}

class ProgressInitial extends ProgressState {
  bool active = false;
  double value = 0;
  double max = 1;
}

class ProgressUpdate extends ProgressState {
  bool active = true;
  double value = 0;
  double max = 1;

  ProgressUpdate(this.value, this.max);
}

class ProgressIncrement extends ProgressState {
  bool active = true;
  double value = progressCubit.state.value + 1;
  double max = progressCubit.state.max;
}

