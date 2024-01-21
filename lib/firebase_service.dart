import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve user details from Firestore
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        return userSnapshot.data() ?? {};
      }

      return {};
    } catch (e) {
      print('Error retrieving user details: $e');
      return {};
    }
  }

  // Update username in Firestore
  Future<void> updateUsername(String newUsername) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'username': newUsername,
        });
      }
    } catch (e) {
      print('Error updating username: $e');
    }
  }
}
