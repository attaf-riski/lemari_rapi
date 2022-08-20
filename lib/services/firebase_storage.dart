import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageLocal {
  Reference ref = FirebaseStorage.instance.ref();

  /// Meletakan file di penyimpnan storage firebase
  Future putFile(image, String clotheId) async {
    String imageURL = '';
    await ref.child(clotheId).putFile(File(image.path));
    await ref
        .child(clotheId)
        .getDownloadURL()
        .then((value) => imageURL = value);
    return imageURL;
  }

  /// menghapus file ketika pakaian dihapus
  Future deleteFile(String clotheId) async {
    return await ref.child(clotheId).delete();
  }
}
