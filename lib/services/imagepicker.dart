import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerLocal {
  Future pickUploudImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 700,
        imageQuality: 75);
    return File(image!.path);
  }
}
