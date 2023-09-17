part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class PrivacyAgreement extends AuthState {}

class Unauthenticated extends AuthState {}

class Register extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
