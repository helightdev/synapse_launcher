import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'launch_state.dart';

var launchCubit = new LaunchCubit();

class LaunchCubit extends Cubit<LaunchState> {
  LaunchCubit() : super(LaunchInitial());
}
