import 'package:lemarirapi/model/clothes.dart';

/// mapping
class UserLocal {
  final String? uid;
  final bool? isVerified;
  UserLocal({this.uid, this.isVerified});
}

class UserData {
  final String? userName, imageURL;
  // berisikan id baju
  final List<Clothes> myClothes;

  UserData({this.userName, this.imageURL, required this.myClothes});

  static UserData fromMap({required Map<dynamic, dynamic> map}) {
    return UserData(
      imageURL: map['imageURL'],
      userName: map['userName'],
      myClothes: map['myClothes'],
    );
  }
}
