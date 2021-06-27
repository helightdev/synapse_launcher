import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:synapse_launcher/models/account.dart';

part 'account_state.dart';

var accountCubit = AccountCubit();

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountStateInitial());
}
