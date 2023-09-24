import '../../exports.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                'SIGN IN',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.0025),
              Text(
                'Welcome back! Nice to meet you again.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w200),
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
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.015),
              CustomizedTextField(
                name: 'password',
                hintText: 'Password',
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  child: Icon(
                    _isObscure
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    size: 20.0,
                  ),
                ),
                obscureText: _isObscure,
                validator: FormBuilderValidators.required(),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.01),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      text: 'Forgot password? ',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Click here',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kPrimaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.03),
              BlocConsumer<AuthCubit, AuthState>(
                builder: ((context, state) {
                  if (state is AuthLoading) {
                    return CustomizedButton(
                      onPressed: () {},
                      label: 'SIGN IN',
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: AppColors.kScaffoldColor,
                      isLoading: true,
                    );
                  } else {
                    return CustomizedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final authCubit = BlocProvider.of<AuthCubit>(context);
                          authCubit.signInWithEmailAndPassword(
                              _formKey.currentState!.fields['email']!.value,
                              _formKey.currentState!.fields['password']!.value);
                        }
                      },
                      label: 'SIGN IN',
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: AppColors.kScaffoldColor,
                    );
                  }
                }),
                listener: (context, state) {
                  if (state is AuthError) {
                    CustomizedDialogBox.errorDialogBox(
                        context, 'Error', state.error.toString());
                  }
                },
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.005),
              Center(
                child: GestureDetector(
                  onTap: () {
                    final authCubit = BlocProvider.of<AuthCubit>(context);
                    authCubit.switchUnauthenticatedState('Register');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Not yet a member? ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'SIGN UP',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kPrimaryColor),
                        )
                      ],
                    ),
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
