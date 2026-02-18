import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= AUTH STATE =================
  Stream<User?> get userChanges => _auth.authStateChanges();

  // ================= REGISTER =================
  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {

    // 1️⃣ Create Firebase Auth user
    UserCredential result =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;

    if (user == null) return null;

    // 2️⃣ Save extra data in Firestore
    Map<String, dynamic> userData = {
      "uid": user.uid,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "role": role,
      "createdAt": Timestamp.now(),
    };

    await _firestore.collection("users").doc(user.uid).set(userData);

    return userData;
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>?> login(
      String email, String password) async {

    // 1️⃣ Sign in
    UserCredential result =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;

    if (user == null) return null;

    // 2️⃣ Fetch Firestore profile
    DocumentSnapshot doc =
        await _firestore.collection("users").doc(user.uid).get();

    if (!doc.exists) return null;

    return doc.data() as Map<String, dynamic>;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
  }
}