part of 'game_running_cubit.dart';

@immutable
abstract class GameRunningState {
  bool isRunning;
}

class GameStopped extends GameRunningState {
  bool isRunning = false;
}

class GameStarted extends GameRunningState {
  bool isRunning = true;
}

