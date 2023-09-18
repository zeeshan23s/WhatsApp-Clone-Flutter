import 'package:shared_preferences/shared_preferences.dart';
import '../../exports.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences prefs;

  AuthCubit() : super(AuthInitial()) {
    _checkCurrentUser();
  }

  Future<void> acceptPrivacyPolicy() async {
    await prefs.setBool('isRunningFirstTime', false);
    emit(Unauthenticated());
  }

  Future<void> _checkCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    prefs = await SharedPreferences.getInstance();
    final bool? isRunningFirstTime = prefs.getBool('isRunningFirstTime');

    if (isRunningFirstTime != null) {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } else {
      emit(PrivacyAgreement());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Login Unsuccessful!'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User user = userCredential.user!;
      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Registration Unsuccessful!'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(Unauthenticated());
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    emit(Unauthenticated());
  }

  Future<void> changeAccountEmail(String newEmail) async {
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void switchUnauthenticatedState(String page) {
    if (page == 'Login') {
      emit(Unauthenticated());
    } else {
      emit(Register());
    }
  }
}
