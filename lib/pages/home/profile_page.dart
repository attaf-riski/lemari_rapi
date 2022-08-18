import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:lemarirapi/model/user.dart';
import 'package:lemarirapi/pages/home/edit_profile_page.dart';
import 'package:lemarirapi/services/firestore_services.dart';
import 'package:lemarirapi/util/jarak_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lemarirapi/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Auth().getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<UserLocal> snapshot) {
          return (snapshot.hasData)
              ? StreamBuilder(
                  stream: FirestoreService().getMyClothe(snapshot.data!.uid!),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> docSnapshot) {
                    var currentUser = docSnapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 157.0,
                                  width: 151.0,
                                  child: (currentUser['imageURL'] == '')
                                      ? Image.asset(
                                          "images/cloud.png",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(currentUser['imageURL'])),
                              smallVerticalGap,
                              Text(
                                currentUser['userName'],
                                style: const TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              smallVerticalGap,
                              TextButton(
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: Colors.black45,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return EditProfilePage(
                                      uid: snapshot.data?.uid!,
                                      userName: currentUser['userName']!,
                                    );
                                  }));
                                },
                              ),
                              largeVerticalGap,
                              SizedBox(
                                  height: 54.0,
                                  child: tombolPilihan("Sign Out", () async {
                                    await signOut();
                                  }))
                            ]),
                      ),
                    );
                  })
              : Container();
        });
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
