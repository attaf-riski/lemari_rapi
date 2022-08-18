import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageLocal {
  Reference ref = FirebaseStorage.instance.ref();

  Future putFile(image, String clotheId) async {
    String imageURL = '';
    await ref.child(clotheId).putFile(File(image.path));
    await ref
        .child(clotheId)
        .getDownloadURL()
        .then((value) => imageURL = value);
    return imageURL;
  }

  Future deleteFile(String clotheId) async {
    return await ref.child(clotheId).delete();
  }
}
