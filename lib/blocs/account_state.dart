part of 'account_cubit.dart';

@immutable
abstract class AccountState {
  bool loaded;
  Account account;

  bool get exists => loaded && account != null;
}

class AccountStateInitial extends AccountState {
  bool loaded = false;
  Account account = null;
}

class AccountStateLoaded extends AccountState {
  bool loaded = true;
  Account account;

  AccountStateLoaded(this.account);
}