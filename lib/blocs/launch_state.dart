part of 'launch_cubit.dart';

@immutable
abstract class LaunchState {
  String configuration;


}

class LaunchInitial extends LaunchState {
  String configuration = "modded";
}

class LaunchUpdated extends LaunchState {
  String configuration = "vanilla";

  LaunchUpdated(this.configuration);
}

