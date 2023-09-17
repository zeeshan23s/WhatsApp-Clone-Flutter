import '../../exports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isObscure = true;

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
                'SIGN UP',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.0025),
              Text(
                'Welcome! Nice to meet you.',
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
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.03),
              BlocConsumer<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CustomizedButton(
                      onPressed: () {},
                      label: 'Sign Up',
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: AppColors.kScaffoldColor,
                      isLoading: true,
                    );
                  } else {
                    return CustomizedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final authCubit = BlocProvider.of<AuthCubit>(context);
                          authCubit.signUpWithEmailAndPassword(
                              _formKey.currentState!.fields['email']!.value,
                              _formKey.currentState!.fields['password']!.value);
                        }
                      },
                      label: 'SIGN UP',
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: AppColors.kScaffoldColor,
                    );
                  }
                },
                listener: (context, state) {
                  if (state is AuthError) {
                    CustomizedDialogBox.errorDialogBox(
                        context, 'Error', state.error.toString());
                  }
                },
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.005),
              GestureDetector(
                onTap: () {
                  final authCubit = BlocProvider.of<AuthCubit>(context);
                  authCubit.switchUnauthenticatedState('Login');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w400),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign in',
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
