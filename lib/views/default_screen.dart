import '../exports.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Responsive.screenHeight(context) * 0.02,
            horizontal: Responsive.screenWidth(context) * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is default screen for the testing purpose!',
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),
            CustomizedButton(
                label: 'Logout',
                onPressed: () {
                  final authCubit = BlocProvider.of<AuthCubit>(context);
                  authCubit.signOut();
                },
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: AppColors.kScaffoldColor)
          ],
        ),
      ),
    );
  }
}
