import '../../exports.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  static final _chatCollection = FirebaseFirestore.instance.collection('Chats');
  static final _userCollection = FirebaseFirestore.instance.collection('Users');

  ChatCubit() : super(ChatInitial());

  Future<void> getChats(String uid) async {
    emit(ChatLoading());

    List<Chat> chats = [];
    List<AppUser> users = [];

    try {
      final chatData =
          await _chatCollection.where('userIds', arrayContains: uid).get();

      for (var doc in chatData.docs) {
        chats.add(Chat(
            chatId: doc['chatId'], chat: doc['chat'], userIds: doc['userIds']));
        if (doc['userIds'][0] == uid) {
          final userData = await _userCollection.doc(doc['userIds'][1]).get();
          users.add(AppUser(
              userId: userData['userId'],
              userName: userData['userName'],
              userEmail: userData['userEmail'],
              profileImageURL: userData['profileImageURL'],
              userAbout: userData['userAbout']));
        } else {
          final userData = await _userCollection.doc(doc['userIds'][0]).get();
          users.add(AppUser(
              userId: userData['userId'],
              userName: userData['userName'],
              userEmail: userData['userEmail'],
              profileImageURL: userData['profileImageURL'],
              userAbout: userData['userAbout']));
        }
      }

      emit(ChatLoaded(chats, users));
    } on FirebaseException catch (e) {
      emit(ChatError(e.message ?? 'Unable to load chats!'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
