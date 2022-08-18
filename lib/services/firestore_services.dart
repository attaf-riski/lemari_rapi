import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _myClothes =
      FirebaseFirestore.instance.collection("users");

  Stream<DocumentSnapshot> getMyClothe(String uid) {
    return _myClothes.doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getMyClothes(String uid) {
    return _myClothes.doc(uid).collection("myClothes").snapshots();
  }

  Future<void> editClothe(
      String uid, String clotheId, String whichField, bool value) async {
    return await _myClothes
        .doc(uid)
        .collection("myClothes")
        .doc(clotheId)
        .update({whichField: value});
  }

  Future<void> editProfile(String uid, String name) async {
    return await _myClothes.doc(uid).update({'userName': name});
  }

  void deleteClothe(String uid, String clotheId) async {
    return await _myClothes
        .doc(uid)
        .collection("myClothes")
        .doc(clotheId)
        .delete();
  }

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

  String clotheId(String uid) {
    return _myClothes.doc(uid).collection("myClothes").id;
  }
}
