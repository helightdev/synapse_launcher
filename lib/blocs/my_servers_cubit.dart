import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:synapse_launcher/models/server.dart';

part 'my_servers_state.dart';

var myServersCubit = MyServersCubit();

class MyServersCubit extends Cubit<MyServersState> {
  MyServersCubit() : super(MyServersInitial());
}
