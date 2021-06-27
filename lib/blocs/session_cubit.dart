import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'session_state.dart';

var sessionCubit = SessionCubit();

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionLoading());
}
