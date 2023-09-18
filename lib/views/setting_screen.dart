import '../exports.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isMenuOpen = false;
  AppUser? appUser;

  @override
  Widget build(BuildContext context) {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLoaded) {
      appUser = userState.appUser;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.kScaffoldColor,
          ),
        ),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.kScaffoldColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchUserScreen(uid: appUser!.userId),
                ),
              );
            },
            icon: const Icon(Icons.search, color: AppColors.kScaffoldColor),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.screenHeight(context) * 0.02,
        ),
        child: Column(
          children: [
            ListTile(
              leading: SizedBox(
                width: Responsive.screenWidth(context) * 0.15,
                child: CircleAvatar(
                  radius: Responsive.screenHeight(context) * 0.15,
                  foregroundImage: NetworkImage(
                    appUser!.profileImageURL ??
                        'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png',
                  ),
                ),
              ),
              title: Text(
                appUser!.userName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              subtitle: Text(
                appUser!.userAbout ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(color: Colors.grey[200]),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth(context) * 0.04),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      CustomizedModelSheets.bottomSheet(
                        context: context,
                        child: _editEmail(
                          context: context,
                          title: 'Enter your new email',
                          field: CustomizedTextField(
                            name: 'email',
                            hintText: 'Email',
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.alternate_email),
                      title: Text(
                        'Change Email',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Did your account has been compromised, changing your email now.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await BlocProvider.of<UserCubit>(context)
                          .deleteUser(appUser!.userId)
                          .whenComplete(() async {
                        await BlocProvider.of<AuthCubit>(context)
                            .deleteAccount()
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: ListTile(
                      leading: const Icon(Icons.remove_moderator),
                      title: Text(
                        'Delete Account',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Removes the Account from the database entirely.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      authCubit.signOut();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(
                        'Logout',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Wish to end the login session.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _editEmail({
    required BuildContext context,
    required String title,
    required Widget field,
  }) {
    final formKey = GlobalKey<FormBuilderState>();
    return FormBuilder(
      key: formKey,
      child: SizedBox(
        height: Responsive.screenHeight(context) * 0.65,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Responsive.screenHeight(context) * 0.04,
                  horizontal: Responsive.screenWidth(context) * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  field,
                  SizedBox(height: Responsive.screenHeight(context) * 0.01),
                  CustomizedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await BlocProvider.of<UserCubit>(context)
                            .updateEmail(appUser!.userId,
                                formKey.currentState!.fields['email']!.value)
                            .whenComplete(() async {
                          await BlocProvider.of<AuthCubit>(context)
                              .changeAccountEmail(
                                  formKey.currentState!.fields['email']!.value)
                              .whenComplete(() {
                            Navigator.pop(context);
                            BlocProvider.of<AuthCubit>(context).signOut();
                            Navigator.pop(context);
                          });
                        });
                      }
                    },
                    label: 'Save',
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: AppColors.kScaffoldColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
