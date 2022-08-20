import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemarirapi/model/user.dart';
import 'package:lemarirapi/pages/home/detail_cloth.dart';
import 'package:lemarirapi/services/auth.dart';
import 'package:lemarirapi/services/firestore_services.dart';
import 'package:lemarirapi/util/jarak_widget.dart';

/// Halaman lemari
/// Menggunakan FutureBuilder untuk mendapatkan user
/// Menggunakan Stream untuk mendapatkan user data di firestore
class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserLocal>(
        future: Auth().getCurrentUser(),
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? StreamBuilder(
                  stream: FirestoreService().getMyClothes(snapshot.data!.uid!),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> docSnapshot) {
                    /// jika docSnapshot ada error
                    if (docSnapshot.hasError) {
                      return const Text('Terjadi Kesalahan');
                    }

                    /// jika docSnapshot sedang menunggu
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

                    /// jika docSnapshot sudah ada data
                    if (docSnapshot.hasData) {
                      QuerySnapshot data = docSnapshot.data!;

                      /// jika user belum menambahkan pakaian
                      if (data.docs.toString() == '[]') {
                        return const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                              child: SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Text(
                              'Kamu belum menambahkan pakaian.',
                              textAlign: TextAlign.center,
                            ),
                          )),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                          ),
                          itemCount: data.size,
                          itemBuilder: (BuildContext context, int index) {
                            /// dapatin data berdasarkan index
                            var currentCloth = data.docs.elementAt(index);

                            /// Mapping data per pakaian ke dalam tiap kartu
                            return cardClothe(
                                nameCloth: currentCloth['clotheName'],
                                idCloth: currentCloth['clotheId'],
                                isAtWardrobe: currentCloth['isAtWardrobe'],
                                isIroned: currentCloth['isIroned'],
                                isWashed: currentCloth['isWashed'],
                                imageURL: currentCloth['imageURL'],
                                description: currentCloth['description'],
                                onTap: () {
                                  //  pergi ke detail pakaian
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return DetailCloth(
                                        uid: snapshot.data!.uid!,
                                        clotheIndex: index);
                                  }));
                                });
                          },
                        ),
                      );
                    } else {
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
                  })
              : const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                      child: SizedBox(
                    width: 25.0,
                    height: 25.0,
                    child: CircularProgressIndicator(),
                  )),
                );
        });
  }

  Container cardClothe(
      {required String nameCloth,
      required String idCloth,
      required String imageURL,
      required String description,
      required bool isAtWardrobe,
      required bool isIroned,
      required bool isWashed,
      required Function onTap}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10)),
      height: 200.0,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: (imageURL == '')
                    ? Image.asset(
                        'images/hoodie.png',
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        imageURL,
                        fit: BoxFit.cover,
                      ),
              ),
              miniVerticalGap,
              Text(
                nameCloth,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: "poppins", fontSize: 10.0, color: Colors.white),
              ),
              miniVerticalGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: isAtWardrobe
                        ? Image.asset('images/wardrobe_on.png')
                        : Image.asset('images/wardrobe_off.png'),
                  ),
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: isIroned
                        ? Image.asset('images/iron_on.png')
                        : Image.asset('images/iron_off.png'),
                  ),
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: isWashed
                        ? Image.asset('images/wash_on.png')
                        : Image.asset('images/wash_off.png'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
