import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'progress_state.dart';


var progressCubit = new ProgressCubit();

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(ProgressInitial());
}
