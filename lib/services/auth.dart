import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lemarirapi/model/user.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final CollectionReference _myClothes =
      FirebaseFirestore.instance.collection("users");

  Future<UserLocal> getCurrentUser() async {
    var buffer = UserLocal(
      uid: currentUser?.uid,
      isVerified: currentUser?.emailVerified,
    );
    return buffer;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      _myClothes
          .doc(value.user?.uid)
          .set({'userName': 'Masukan nama', 'imageURL': ''});
      _myClothes.doc(value.user?.uid).collection("myClothes");
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  var acs = ActionCodeSettings(
      url: 'https://lemarirapi-aee5e.firebaseapp.com',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.lemarirapi',
      androidPackageName: 'com.example.lemarirapi',
      androidInstallApp: true,
      androidMinimumVersion: '19');

  Future<void> sendEmailVerification({required String email}) async {
    currentUser?.sendEmailVerification();
  }

  Future<void> sendResetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword({required String password}) async {
    await currentUser?.updatePassword(password);
  }
}
