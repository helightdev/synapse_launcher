part of 'progress_cubit.dart';

@immutable
abstract class ProgressState {
  bool active;
  double value;
  double max;
  bool isNull = false;

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
  bool isNull = false;
}

class ProgressUpdate extends ProgressState {
  bool active = true;
  double value = 0;
  double max = 1;
  bool isNull = false;

  ProgressUpdate(this.value, this.max, {this.isNull = false});
}

class ProgressIncrement extends ProgressState {
  bool active = true;
  double value = progressCubit.state.value + 1;
  double max = progressCubit.state.max;
  bool isNull = false;
}

