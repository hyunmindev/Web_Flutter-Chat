import 'package:cloud_firestore/cloud_firestore.dart';

void createChat(docID, chat) {
  FirebaseFirestore.instance
      .collection('ROOM')
      .doc(docID)
      .collection('CHAT')
      .add({...chat, 'time': DateTime.now()}).then((value) {
    print('chat created');
  }).catchError((error) {
    print("Failed to read chats: $error");
  });
}
