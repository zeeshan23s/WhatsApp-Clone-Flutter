import '../../exports.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.screenWidth(context) * 0.02,
              vertical: Responsive.screenHeight(context) * 0.05),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('Almost there!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w900)),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.12),
              Align(
                alignment: Alignment.center,
                child: Text('Just follow the link we sent to: $email',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.12),
              Icon(Icons.mail_outlined,
                  size: Responsive.screenHeight(context) * 0.1),
              SizedBox(height: Responsive.screenHeight(context) * 0.08),
              CustomizedButton(
                onPressed: () async {
                  await OpenMailApp.openMailApp().then((result) => {
                        if (!result.didOpen && !result.canOpen)
                          {showNoMailAppsDialog(context)}
                        else if (!result.didOpen && result.canOpen)
                          {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return MailAppPickerDialog(
                                  mailApps: result.options,
                                );
                              },
                            )
                          }
                      });
                },
                label: 'Open my email app',
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: AppColors.kScaffoldColor,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.025),
              CustomizedButton(
                onPressed: () {
                  final authCubit = BlocProvider.of<AuthCubit>(context);
                  authCubit.signOut();
                },
                label: 'Logout',
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: AppColors.kScaffoldColor,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.025),
              GestureDetector(
                onTap: () {
                  final authCubit = BlocProvider.of<AuthCubit>(context);
                  AuthState authState = authCubit.state;
                  if (authState is Authenticated) {
                    final emailVerificationCubit =
                        BlocProvider.of<EmailVerificationCubit>(context);
                    emailVerificationCubit
                        .sendVerificationEmail(authState.user);
                    EmailVerificationState emailVerificationState =
                        emailVerificationCubit.state;
                    if (emailVerificationState is EmailVerificationError) {
                      CustomizedDialogBox.errorDialogBox(context, 'Error',
                          emailVerificationState.error.toString());
                    }
                  }
                },
                child: Text(
                  'I did not receive an email',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.091),
              Text(
                'Note: After Verifying your email. Logout to re-authenticate!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.screenHeight(context) * 0.012),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
