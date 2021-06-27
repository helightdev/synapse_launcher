part of 'my_servers_cubit.dart';

@immutable
abstract class MyServersState {
  bool loaded;
  List<Server> servers;
}

class MyServersInitial extends MyServersState {
  bool loaded = false;
  List<Server> servers = new List.empty();
}

class MyServersLoaded extends MyServersState {
  bool loaded = true;
  List<Server> servers;

  MyServersLoaded(this.servers);
}

