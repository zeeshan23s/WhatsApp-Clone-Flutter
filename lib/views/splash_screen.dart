import '../exports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is Authenticated) {
        final emailVerificationCubit =
            BlocProvider.of<EmailVerificationCubit>(context);
        emailVerificationCubit.checkEmailVerified(state.user);
        final userCubit = BlocProvider.of<UserCubit>(context);
        userCubit.checkUserInfo(state.user.uid);
      }
    }, builder: (context, state) {
      if (state is AuthInitial) {
        return _initialBuild(context);
      } else if (state is PrivacyAgreement) {
        return const PrivacyPolicyScreen();
      } else if (state is Authenticated) {
        return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
            builder: (context, emailVerificationState) {
              if (emailVerificationState is EmailVerified) {
                return BlocConsumer<UserCubit, UserState>(
                    builder: (context, userState) {
                      if (userState is UserLoaded) {
                        if (userState.appUser != null) {
                          return const DefaultScreen();
                        } else {
                          return const NewUserScreen();
                        }
                      } else {
                        return const LoadingScreen();
                      }
                    },
                    listener: (context, state) {});
              } else {
                return EmailVerificationScreen(email: state.user.email!);
              }
            },
            listener: (context, state) {});
      } else if (state is Register) {
        return const SignUpScreen();
      } else {
        return const SignInScreen();
      }
    });
  }

  Widget _initialBuild(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Responsive.screenHeight(context) * 0.02,
              horizontal: Responsive.screenWidth(context) * 0.04),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: EntranceFader(
                    offset: const Offset(0, 20),
                    duration: const Duration(milliseconds: 1500),
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        AppAssets.logoPNG,
                        height: Responsive.screenWidth(context) * 0.25,
                        width: Responsive.screenWidth(context) * 0.25,
                      ),
                    ),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'from\n',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'FACEBOOK',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kPrimaryColor),
                        )
                      ]),
                )
              ],
            ),
          ),
        ),
      );
}
