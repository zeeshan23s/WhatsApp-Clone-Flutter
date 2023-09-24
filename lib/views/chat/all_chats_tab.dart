import '../../exports.dart';

class AllChatsScreen extends StatefulWidget {
  final AppUser user;
  const AllChatsScreen({super.key, required this.user});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  @override
  void initState() {
    super.initState();
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    chatCubit.getChats(widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      if (state is ChatError) {
        return Center(
          child:
              Text(state.error, style: Theme.of(context).textTheme.bodyMedium),
        );
      } else if (state is ChatLoaded) {
        return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => ChatScreen(
                          receiverUser: state.users[index],
                          chat: state.chats[index])),
                    ),
                  );
                },
                leading: SizedBox(
                  width: Responsive.screenWidth(context) * 0.15,
                  child: CircleAvatar(
                    radius: Responsive.screenHeight(context) * 0.15,
                    foregroundImage: NetworkImage(
                      state.users[index].profileImageURL ??
                          'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png',
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.users[index].userName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      lastMessageTime(state.chats[index]),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
                subtitle: Text(
                  state.chats[index].chat.last['messages'].last['message'] ??
                      '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
              );
            });
      } else {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.kPrimaryColor));
      }
    });
  }

  String lastMessageTime(Chat chat) {
    DateTime currentDate = DateTime.now();
    if (chat.chat.last['date'] ==
        '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year.toString().padLeft(4, '0')}') {
      return chat.chat.last['messages'].last['time'];
    } else if (chat.chat.last['date'] ==
        '${currentDate.subtract(const Duration(days: 1)).day.toString().padLeft(2, '0')}/${currentDate.subtract(const Duration(days: 1)).month.toString().padLeft(2, '0')}/${currentDate.subtract(const Duration(days: 1)).year.toString().padLeft(4, '0')}') {
      return 'Yesterday';
    } else {
      return chat.chat.last['date'];
    }
  }
}
