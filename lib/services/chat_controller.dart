import '../exports.dart';

class ChatController {
  static final _chatCollection = FirebaseFirestore.instance.collection('Chats');

  static Future<void> sendMessage(
      {Chat? chat,
      required String message,
      required List<String> userIds,
      required String senderId}) async {
    Chat? findedChat;
    if (chat == null) {
      QuerySnapshot query = await _chatCollection
          .where('userIds', arrayContains: userIds[0])
          .get();
      if (query.docs.isNotEmpty) {
        QueryDocumentSnapshot? findedChats = query.docs.firstWhere(
          (doc) => doc.get('userIds').contains(
                userIds[1],
              ),
        );
        if (findedChats.exists) {
          DocumentSnapshot firstChat = findedChats;
          findedChat = Chat(
              chatId: firstChat['chatId'],
              chat: firstChat['chat'],
              userIds: firstChat['userIds']);
        }
      }
    }

    List<dynamic> newChat = chat != null
        ? chat.chat
        : findedChat != null
            ? findedChat.chat
            : [];

    // List<Map<String, dynamic>> messages = [
    //   {
    //     'date': '20/09/2023',
    //     'messages': [
    //       {
    //         'senderId': 'rnnqC5njFfemg0qGz9qSHn323lm1',
    //         'time': '09:30',
    //         'message': '123'
    //       }
    //     ]
    //   },
    //   {'date': '21/09/2023', 'message': '2'}
    // ];

    Map<String, dynamic>? todayMessages = newChat.where((element) {
      return element['date'] ==
          '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(4, '0')}';
    }).firstOrNull;

    if (todayMessages != null) {
      newChat.remove(todayMessages);

      todayMessages['messages'].add({
        'message': message,
        'time':
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'senderId': senderId
      });

      newChat.add(todayMessages);
    } else {
      newChat.add({
        'date':
            '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(4, '0')}',
        'messages': [
          {
            'message': message,
            'time':
                '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            'senderId': senderId
          }
        ]
      });
    }

    // newChat.add({
    //   'message': message,
    //   'datetime': Timestamp.now(),
    //   'senderId': senderId
    // });

    if (chat != null) {
      await _chatCollection.doc(chat.chatId).set(
          Chat(chatId: chat.chatId, chat: newChat, userIds: chat.userIds)
              .toMap());
    } else if (findedChat != null) {
      await _chatCollection.doc(findedChat.chatId).set(Chat(
              chatId: findedChat.chatId,
              chat: newChat,
              userIds: findedChat.userIds)
          .toMap());
    } else {
      await _chatCollection
          .add(
        Chat(chatId: '', chat: newChat, userIds: userIds).toMap(),
      )
          .then((value) {
        _chatCollection.doc(value.id).update({'chatId': value.id});
      });
    }
  }
}
