import 'package:flutter/Material.dart';
import 'package:lemarirapi/util/jarak_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lemarirapi/auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(10)),
            height: 157.0,
            width: 151.0,
            child: Image.asset(
              "images/cloud.png",
              fit: BoxFit.contain,
            ),
          ),
          smallVerticalGap,
          const Text(
            "Attaf Riski",
            style: TextStyle(
                fontFamily: "poppins",
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
          smallVerticalGap,
          TextButton(
            child: const Text(
              "Edit Profile",
              style: TextStyle(
                  fontFamily: "poppins", color: Colors.black45, fontSize: 16.0),
            ),
            onPressed: () {},
          ),
          largeVerticalGap,
          SizedBox(height: 54.0, child: tombolPilihan("Ganti Password", () {})),
          smallVerticalGap,
          SizedBox(
              height: 54.0,
              child: tombolPilihan("Sign Out", () async {
                await signOut();
              }))
        ]),
      ),
    );
  }
}

ElevatedButton tombolPilihan(String pesan, Function tujuanDitekan) {
  return ElevatedButton(
      onPressed: () => tujuanDitekan(),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          )),
      child: Center(
        child: Text(
          pesan,
          style: const TextStyle(
              fontFamily: "poppins",
              color: Colors.blue,
              fontSize: 16.0,
              fontWeight: FontWeight.w500),
        ),
      ));
}
