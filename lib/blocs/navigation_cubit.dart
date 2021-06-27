import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

var navigationCubit = NavigationCubit();

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
}
