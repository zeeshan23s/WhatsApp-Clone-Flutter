part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final AppUser? appUser;
  UserLoaded(this.appUser);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}
