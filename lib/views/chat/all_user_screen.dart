import '../../exports.dart';

class AllUsersScreen extends StatefulWidget {
  final String uid;
  const AllUsersScreen({super.key, required this.uid});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
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
            'Select Contact',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.kScaffoldColor),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchUserScreen(uid: widget.uid),
                  ),
                );
              },
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
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Responsive.screenHeight(context) * 0.02,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('userId', isNotEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> users =
                        snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: SizedBox(
                              width: Responsive.screenWidth(context) * 0.15,
                              child: CircleAvatar(
                                radius: Responsive.screenHeight(context) * 0.15,
                                foregroundImage: NetworkImage(
                                  users[index]['profileImageURL'] ??
                                      'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png',
                                ),
                              ),
                            ),
                            title: Text(
                              users[index]['userName'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            subtitle: Text(
                              users[index]['userAbout'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kPrimaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
            isMenuOpen
                ? Positioned(
                    right: Responsive.screenWidth(context) * 0.04,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.screenHeight(context) * 0.020,
                        horizontal: Responsive.screenWidth(context) * 0.06,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.kScaffoldColor,
                          borderRadius: BorderRadius.circular(
                              Responsive.screenWidth(context) * 0.025),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.kSecondaryColor.withOpacity(0.1),
                              offset: const Offset(1, 1),
                            ),
                            BoxShadow(
                              color: AppColors.kSecondaryColor.withOpacity(0.1),
                              offset: const Offset(-1, -1),
                            ),
                          ]),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.settings, size: 20),
                            SizedBox(
                                width: Responsive.screenWidth(context) * 0.025),
                            Text(
                              'Settings',
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
