import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Users {
  final String uid;
  final String email;
  String fullName;

  Users({required this.uid, required this.email, required this.fullName});

  Users.fromJson(Map<String, Object?> jsonMap)
      : this(
            uid: jsonMap['uid'] as String,
            email: jsonMap['email'] as String,
            fullName: jsonMap['username'] as String);

  Map<String, Object?> toJson() {
    return {'uid': uid, 'email': email, 'username': fullName};
  }

  @override
  String toString() {
    return 'Users{uid: $uid, email: $email, username: $fullName}';
  }

  static Future<void> addCurrentUserToFirestore() async {
    try {
      await Firebase.initializeApp();
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersCollection = firestore.collection('users');

        String username = user.email?.split('@').first ?? '';

        Users currentUser = Users(
          uid: user.uid,
          email: user.email ?? '',
          fullName: user.displayName ?? '',
        );
        currentUser.fullName = username;

        await usersCollection.doc(currentUser.uid).set(currentUser.toJson());
      } else {
        print('No user is currently authenticated.');
      }
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

    Future<Users> getCurrentUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return Users.fromJson(userSnapshot.data() as Map<String, dynamic>);
      } else {
        print('User not found in the Users collection.');
        return Users(
            uid: '',
            email: '',
            fullName:
                ''); // Return a default value or handle the case appropriately
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return Users(
          uid: '',
          email: '',
          fullName:
              ''); // Return a default value or handle the error appropriately
    }
  }
}
