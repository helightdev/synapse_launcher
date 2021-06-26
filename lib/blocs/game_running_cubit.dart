import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'game_running_state.dart';

var gameRunningCubit = new GameRunningCubit();

class GameRunningCubit extends Cubit<GameRunningState> {
  GameRunningCubit() : super(GameStopped());
}
