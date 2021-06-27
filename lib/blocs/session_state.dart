part of 'session_cubit.dart';

@immutable
abstract class SessionState {
  bool loaded;
  String session;
}

class SessionLoading extends SessionState {
  bool loaded = false;
  String session = "";
}

class SessionLoaded extends SessionState {
  bool loaded = true;
  String session = "";

  SessionLoaded(this.session);
}

