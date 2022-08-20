import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _myClothes =
      FirebaseFirestore.instance.collection("users");

  /// dapatkan user data sekarang
  Stream<DocumentSnapshot> getMyClothe(String uid) {
    return _myClothes.doc(uid).snapshots();
  }

  /// dapatkan koleksi baju
  Stream<QuerySnapshot> getMyClothes(String uid) {
    return _myClothes.doc(uid).collection("myClothes").snapshots();
  }

  /// mengedit pakaian
  Future<void> editClothe(
      String uid, String clotheId, String whichField, bool value) async {
    return await _myClothes
        .doc(uid)
        .collection("myClothes")
        .doc(clotheId)
        .update({whichField: value});
  }

  /// mengedit profile
  Future<void> editProfile(String uid, String name) async {
    return await _myClothes.doc(uid).update({'userName': name});
  }

  /// hapus pakaian
  void deleteClothe(String uid, String clotheId) async {
    return await _myClothes
        .doc(uid)
        .collection("myClothes")
        .doc(clotheId)
        .delete();
  }

  /// menambahkan pakaian
  Future<void> addClothe({
    required String uid,
    required String clotheName,
    required String clotheId,
    required String imageURL,
    required String description,
    required bool isWashed,
    required bool isIroned,
    required bool isAtWardrobe,
  }) async {
    return await _myClothes.doc(uid).collection("myClothes").doc(clotheId).set({
      'clotheName': clotheName,
      'clotheId': clotheId,
      'description': description,
      'imageURL': imageURL,
      'isAtWardrobe': isAtWardrobe,
      'isWashed': isWashed,
      'isIroned': isIroned
    });
  }
}
