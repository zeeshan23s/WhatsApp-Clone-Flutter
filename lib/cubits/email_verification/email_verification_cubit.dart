import '../../exports.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit() : super(EmailVerificationInitial());

  Future<void> checkEmailVerified(User appUser) async {
    bool isVerified = appUser.emailVerified;
    if (isVerified) {
      emit(EmailVerified());
    } else {
      emit(EmailUnverified(appUser.email!));
    }
  }

  Future<void> sendVerificationEmail(User appUser) async {
    try {
      await appUser.sendEmailVerification();
    } on FirebaseException catch (e) {
      emit(EmailVerificationError(
          e.message ?? 'Unable to send verification email!'));
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }
}
