import 'package:chat_app/views/profile/profile_tab.dart';
import '../exports.dart';

class HomeScreen extends StatefulWidget {
  final AppUser appUser;
  const HomeScreen({super.key, required this.appUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;

  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMenuOpen = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          title: Text(
            'WhatsApp Clone',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.kScaffoldColor),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: AppColors.kScaffoldColor),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
              icon:
                  const Icon(Icons.more_vert, color: AppColors.kScaffoldColor),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tabIndex = 0;
                          });
                        },
                        child: Container(
                          height: Responsive.screenHeight(context) * 0.075,
                          color: AppColors.kPrimaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Chat',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.kScaffoldColor),
                                  ),
                                ),
                              ),
                              tabIndex == 0
                                  ? Divider(
                                      indent: Responsive.screenWidth(context) *
                                          0.01,
                                      color: AppColors.kScaffoldColor,
                                      height: Responsive.screenHeight(context) *
                                          0.0075,
                                      thickness:
                                          Responsive.screenHeight(context) *
                                              0.005)
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tabIndex = 1;
                          });
                        },
                        child: Container(
                          height: Responsive.screenHeight(context) * 0.075,
                          color: AppColors.kPrimaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.kScaffoldColor),
                                  ),
                                ),
                              ),
                              tabIndex == 1
                                  ? Divider(
                                      indent: Responsive.screenWidth(context) *
                                          0.01,
                                      color: AppColors.kScaffoldColor,
                                      height: Responsive.screenHeight(context) *
                                          0.0075,
                                      thickness:
                                          Responsive.screenHeight(context) *
                                              0.005)
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: tabIndex == 0
                        ? Container()
                        : ProfileTab(appUser: widget.appUser))
              ],
            ),
            isMenuOpen
                ? Positioned(
                    right: Responsive.screenWidth(context) * 0.04,
                    child: GestureDetector(
                      onTap: () {
                        final authCubit = BlocProvider.of<AuthCubit>(context);
                        authCubit.signOut();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.screenHeight(context) * 0.020,
                          horizontal: Responsive.screenWidth(context) * 0.06,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.kScaffoldColor,
                            borderRadius: BorderRadius.circular(
                                Responsive.screenWidth(context) * 0.025)),
                        child: Row(
                          children: [
                            const Icon(Icons.logout, size: 20),
                            SizedBox(
                                width: Responsive.screenWidth(context) * 0.025),
                            Text(
                              'Logout',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
