import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:lemarirapi/model/user.dart';
import 'package:lemarirapi/pages/home/edit_profile_page.dart';
import 'package:lemarirapi/services/firestore_services.dart';
import 'package:lemarirapi/util/jarak_widget.dart';
import 'package:lemarirapi/services/auth.dart';

/// Halaman koding profile page
/// Menggunakan futurebuilder sebagai pengambilan user sekarang
/// Menggunakan streambuilder sebagai pengambilan data user sekarang
/// Pemisahan services dan ui dilakukan juga di halaman ini

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  /// Method signout
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
                    /// Jika error ditampilkan ini
                    if (docSnapshot.hasError) {
                      return const Center(
                        child: Text("Terjadi kesalahan"),
                      );
                    }

                    if (docSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                            child: SizedBox(
                          width: 25.0,
                          height: 25.0,
                          child: CircularProgressIndicator(),
                        )),
                      );
                    }

                    /// Jika snapshot null ditampilkan ini
                    if (docSnapshot.data == null) {
                      return const Center(
                        child: Text("Terjadi kesalahan"),
                      );
                    }

                    /// Jika aman-aman saja ditampilkan ini
                    var currentUser = docSnapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: ListView(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  largeVerticalGap,
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 157.0,
                                      width: 151.0,
                                      child: (currentUser['imageURL'] == '')
                                          ? Image.asset(
                                              "images/cloud.png",
                                              fit: BoxFit.contain,
                                            )
                                          : Image.network(
                                              currentUser['imageURL'])),
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
                                  SizedBox(
                                      height: 54.0,
                                      child:
                                          tombolPilihan("Sign Out", () async {
                                        /// perintah signout
                                        await signOut();
                                      }))
                                ]),
                          ),
                        ],
                      ),
                    );
                  })
              : Container();
        });
  }

  ElevatedButton tombolPilihan(String pesan, Function tujuanDitekan) {
    return ElevatedButton(
        onPressed: () => tujuanDitekan(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black)),
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
}
