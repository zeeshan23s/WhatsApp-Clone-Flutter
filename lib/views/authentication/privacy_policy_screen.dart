import '../../exports.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Responsive.screenHeight(context) * 0.04,
              horizontal: Responsive.screenWidth(context) * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome to WhatsApp',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w700),
              ),
              Image.asset(
                AppAssets.privacyPNG,
                color: AppColors.kPrimaryColor,
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Tab "Agree and Continue" to accept the ',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'WhatsApp Terms of Service and Privacy Policy',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kPrimaryColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.screenHeight(context) * 0.025),
                  CustomizedButton(
                      label: 'AGREE AND CONTINUE',
                      onPressed: () {
                        final authCubit = BlocProvider.of<AuthCubit>(context);
                        authCubit.acceptPrivacyPolicy();
                      },
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: AppColors.kScaffoldColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
