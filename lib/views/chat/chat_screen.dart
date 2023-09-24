import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import '../../exports.dart';

class ChatScreen extends StatefulWidget {
  final AppUser receiverUser;
  final Chat? chat;
  const ChatScreen({super.key, required this.receiverUser, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;
    if (authState is Authenticated) {
      BlocProvider.of<MessageCubit>(context).getMessages(
          chat: widget.chat,
          userIds: [authState.user.uid, widget.receiverUser.userId]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        leading: IconButton(
            padding:
                EdgeInsets.only(left: Responsive.screenWidth(context) * 0.035),
            onPressed: () {
              final authState = BlocProvider.of<AuthCubit>(context).state;
              if (authState is Authenticated) {
                final chatCubit = BlocProvider.of<ChatCubit>(context);
                chatCubit.getChats(authState.user.uid);
              }
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.arrow_back, color: AppColors.kScaffoldColor)),
        leadingWidth: Responsive.screenWidth(context) * 0.075,
        title: WillPopScope(
          onWillPop: () async {
            if (emojiShowing) {
              setState(() {
                emojiShowing = !emojiShowing;
              });
              return false;
            } else {
              final authState = BlocProvider.of<AuthCubit>(context).state;
              if (authState is Authenticated) {
                final chatCubit = BlocProvider.of<ChatCubit>(context);
                chatCubit.getChats(authState.user.uid);
              }
              return true;
            }
          },
          child: Row(
            children: [
              SizedBox(width: Responsive.screenWidth(context) * 0.01),
              CircleAvatar(
                radius: Responsive.screenWidth(context) * 0.05,
                foregroundImage: NetworkImage(widget
                        .receiverUser.profileImageURL ??
                    'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),
              ),
              SizedBox(width: Responsive.screenWidth(context) * 0.02),
              Text(
                widget.receiverUser.userName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.kScaffoldColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.kScaffoldColor),
          ),
        ],
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.5,
                  image: AssetImage('assets/images/chat-background-image.png'),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Color(0xFFF3F0EA), BlendMode.difference),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Chats')
                          .doc(state.chat != null
                              ? state.chat!.chatId
                              : '0000000000')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.exists) {
                            List<dynamic> chatMessages = snapshot.data!['chat'];
                            return ListView.builder(
                                itemCount: chatMessages.length,
                                itemBuilder: (context, index) {
                                  return chatDateContainer(
                                      chatMessages[index]['date'],
                                      chatMessages[index]['messages']);
                                });
                          } else {
                            return const SizedBox();
                          }
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.screenHeight(context) * 0.01,
                        horizontal: Responsive.screenWidth(context) * 0.025),
                    child: Row(
                      children: [
                        FormBuilder(
                          child: Expanded(
                            child: FormBuilderTextField(
                              textInputAction: TextInputAction.done,
                              controller: _messageController,
                              name: 'message',
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
                                  icon: const Icon(Icons.attach_file),
                                ),
                                hintText: 'Message',
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      emojiShowing = true;
                                    });
                                  },
                                  icon:
                                      const Icon(Icons.emoji_emotions_outlined),
                                ),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        letterSpacing: 1,
                                        color: AppColors.kSecondaryColor),
                                fillColor: AppColors.kScaffoldColor,
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
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.screenWidth(context) * 0.01),
                        InkWell(
                          onTap: () {
                            AuthState authState =
                                BlocProvider.of<AuthCubit>(context).state;
                            if (authState is Authenticated) {
                              MessageCubit messageCubit =
                                  BlocProvider.of<MessageCubit>(context);
                              messageCubit.sendMessage(
                                  message: _messageController.text,
                                  senderId: authState.user.uid,
                                  userIds: [
                                    authState.user.uid,
                                    widget.receiverUser.userId
                                  ]).whenComplete(
                                  () => _messageController.clear());
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.kPrimaryColor,
                            radius: Responsive.screenWidth(context) * 0.065,
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                color: AppColors.kScaffoldColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: !emojiShowing,
                    child: SizedBox(
                        height: 250,
                        child: EmojiPicker(
                          textEditingController: _messageController,
                          onBackspacePressed: _onBackspacePressed,
                          config: const Config(
                            columns: 7,
                            emojiSizeMax: 24,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: AppColors.kScaffoldColor,
                            indicatorColor: AppColors.kPrimaryColor,
                            iconColor: Colors.grey,
                            iconColorSelected: AppColors.kPrimaryColor,
                            backspaceColor: AppColors.kPrimaryColor,
                            skinToneDialogBgColor: AppColors.kScaffoldColor,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            recentTabBehavior: RecentTabBehavior.RECENT,
                            recentsLimit: 28,
                            replaceEmojiOnLimitExceed: false,
                            noRecents: Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                            loadingIndicator: SizedBox.shrink(),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                            checkPlatformCompatibility: true,
                          ),
                          onEmojiSelected: (category, emoji) {
                            setState(() {
                              emojiShowing = false;
                            });
                          },
                        )),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.kPrimaryColor));
          }
        },
      ),
    );
  }

  _onBackspacePressed() {
    _messageController
      ..text = _messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
  }

  Widget chatDateContainer(String date, List<dynamic> messages) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: Responsive.screenHeight(context) * 0.025),
          padding: EdgeInsets.symmetric(
              vertical: Responsive.screenHeight(context) * 0.015,
              horizontal: Responsive.screenWidth(context) * 0.015),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  Responsive.screenWidth(context) * 0.025),
              color: AppColors.kScaffoldColor.withOpacity(0.8)),
          child: Text(
            messageDate(date),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        ...messages.asMap().entries.map((e) {
          return e.value['senderId'] != widget.receiverUser.userId
              ? ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.025),
                  backGroundColor: AppColors.kPrimaryColor,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.screenWidth(context) * 0.7,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.screenWidth(context) * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          e.value['message'],
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.kScaffoldColor,
                                  ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                            height: Responsive.screenHeight(context) * 0.005),
                        Text(
                          e.value['time'],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.kScaffoldColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                )
              : ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  backGroundColor: AppColors.kScaffoldColor,
                  margin: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.025),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.screenWidth(context) * 0.7,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.screenWidth(context) * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          e.value['message'],
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.kSecondaryColor,
                                  ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                            height: Responsive.screenHeight(context) * 0.005),
                        Text(
                          e.value['time'],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.kSecondaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
        }).toList()
      ],
    );
  }

  String messageDate(String date) {
    DateTime currentDate = DateTime.now();
    if (date ==
        '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year.toString().padLeft(4, '0')}') {
      return 'Today';
    } else if (date ==
        '${currentDate.subtract(const Duration(days: 1)).day.toString().padLeft(2, '0')}/${currentDate.subtract(const Duration(days: 1)).month.toString().padLeft(2, '0')}/${currentDate.subtract(const Duration(days: 1)).year.toString().padLeft(4, '0')}') {
      return 'Yesterday';
    } else {
      return date;
    }
  }
}
