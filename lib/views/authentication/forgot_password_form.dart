import '../../exports.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Responsive.screenHeight(context) * 0.04,
              horizontal: Responsive.screenWidth(context) * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.logoPNG,
                height: Responsive.screenWidth(context) * 0.35,
                color: AppColors.kPrimaryColor,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.025),
              Text(
                'Forgot Password',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.01),
              Text(
                'Forgot your password? It\'s okay. We all forgot things sometimes.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.04),
              CustomizedTextField(
                name: 'email',
                hintText: 'Email',
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.03),
              CustomizedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email:
                                  _formKey.currentState!.fields['email']!.value)
                          .whenComplete(() {
                        Navigator.pop(context);
                        CustomizedDialogBox.errorDialogBox(
                            context,
                            'Reset Password',
                            'Password reset email have been send to your email!');
                      });
                    } on FirebaseException catch (e) {
                      CustomizedDialogBox.errorDialogBox(
                          context, 'Error', e.message ?? " ");
                    } catch (e) {
                      CustomizedDialogBox.errorDialogBox(
                          context, 'Error', e.toString());
                    }
                  }
                },
                label: 'Submit',
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: AppColors.kScaffoldColor,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.005),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Remember your password? ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w400),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Click here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.kPrimaryColor),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
