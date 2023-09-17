part of 'email_verification_cubit.dart';

abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerified extends EmailVerificationState {}

class EmailUnverified extends EmailVerificationState {
  final String email;
  EmailUnverified(this.email);
}

class EmailVerificationError extends EmailVerificationState {
  final String error;
  EmailVerificationError(this.error);
}
