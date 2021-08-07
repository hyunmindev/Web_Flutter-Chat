import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot?> readUsers() {
  return FirebaseFirestore.instance
      .collection('ROOM')
      .get()
      .then((QuerySnapshot querySnapshot) {
    return querySnapshot;
  }).catchError((error) {
    print("Failed to read rooms: $error");
  });
}
