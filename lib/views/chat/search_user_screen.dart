import '../../exports.dart';

class SearchUserScreen extends StatefulWidget {
  final String uid;
  const SearchUserScreen({super.key, required this.uid});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String? searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.screenHeight(context) * 0.02,
            horizontal: Responsive.screenWidth(context) * 0.04,
          ),
          child: Column(
            children: [
              FormBuilder(
                child: FormBuilderTextField(
                  textInputAction: TextInputAction.done,
                  name: 'search',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.kSecondaryColor),
                  cursorColor: AppColors.kPrimaryColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: 'Search',
                    prefixIcon: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        letterSpacing: 1, color: AppColors.kSecondaryColor),
                    fillColor: Colors.grey[200],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.screenHeight(context) * 0.25,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.screenHeight(context) * 0.25,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          Responsive.screenHeight(context) * 0.25),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(244, 67, 54, 1),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.screenHeight(context) * 0.25,
                      ),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(244, 67, 54, 1),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.025),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('userId', isNotEqualTo: widget.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> users =
                          [];
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          searchUsers = snapshot.data!.docs;

                      if (searchText == null) {
                        users = searchUsers;
                      } else {
                        for (QueryDocumentSnapshot<Map<String, dynamic>> user
                            in searchUsers) {
                          if (user['userName'].contains(searchText)) {
                            users.add(user);
                          }
                        }
                      }
                      return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => ChatScreen(
                                        receiverUser: AppUser(
                                            userId: users[index]['userId'],
                                            userName: users[index]['userName'],
                                            userAbout: users[index]
                                                ['userAbout'],
                                            userEmail: users[index]
                                                ['userEmail'],
                                            profileImageURL: users[index]
                                                ['profileImageURL']),
                                        chat: null)),
                                  ),
                                );
                              },
                              leading: SizedBox(
                                width: Responsive.screenWidth(context) * 0.2,
                                child: CircleAvatar(
                                  radius:
                                      Responsive.screenHeight(context) * 0.15,
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
            ],
          ),
        ),
      ),
    );
  }
}
