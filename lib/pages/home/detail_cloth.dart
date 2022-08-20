import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemarirapi/services/firebase_storage.dart';
import 'package:lemarirapi/services/firestore_services.dart';
import 'package:lemarirapi/util/jarak_widget.dart';

/// Menggunakan Streambuilder
class DetailCloth extends StatefulWidget {
  /// ada data yang dikirim dari wardrobe utama
  final String uid;
  final int clotheIndex;
  const DetailCloth({Key? key, required this.uid, required this.clotheIndex})
      : super(key: key);

  @override
  State<DetailCloth> createState() => _DetailClothState();
}

class _DetailClothState extends State<DetailCloth> {
  /// Untuk nilai dari switch widget
  bool isAtWardrobeSwitchValue = false;
  bool isIronedSwitchValue = false;
  bool isWashedSwitchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirestoreService().getMyClothes(widget.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> docSnapshot) {
            /// Jika snaphot error
            if (docSnapshot.hasError) {
              return const Text('Something went wrong');
            }

            /// Jika snaphot sedang menunggu data
            if (docSnapshot.connectionState == ConnectionState.waiting) {
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

            /// Jika snaphot sudah ada data
            QuerySnapshot data = docSnapshot.data!;

            /// Mapping data pakaian sesuai index yang dikirim dari wardrobe utama
            var currentClothData = data.docs.elementAt(widget.clotheIndex);
            //  atur keadaan pakaian sekarang mengikuti data di firestore
            isAtWardrobeSwitchValue = currentClothData['isAtWardrobe'];
            isIronedSwitchValue = currentClothData['isIroned'];
            isWashedSwitchValue = currentClothData['isWashed'];
            return SafeArea(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        mediumVerticalGap,
                        SizedBox(
                          height: 186.0,
                          width: 159.0,
                          child: (currentClothData['imageURL'] == '')
                              ? Image.asset(
                                  "images/hoodie.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  currentClothData['imageURL'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                        smallVerticalGap,
                        Text(
                          currentClothData['clotheName'],
                          style: const TextStyle(
                              fontFamily: "poppins",
                              fontSize: 20.0,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.w700),
                        ),
                        mediumVerticalGap,
                        // on off
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 29,
                                  height: 29,
                                  child: isAtWardrobeSwitchValue
                                      ? Image.asset('images/wardrobe_on.png')
                                      : Image.asset('images/wardrobe_off.png'),
                                ),
                                const Text(
                                  "Sudah ditaruh dilemari?",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black54,
                                  ),
                                ),
                                Switch(
                                    value: isAtWardrobeSwitchValue,
                                    onChanged: (value) async {
                                      setState(() {
                                        isAtWardrobeSwitchValue = value;
                                      });
                                      await FirestoreService().editClothe(
                                          widget.uid,
                                          currentClothData['clotheId'],
                                          'isAtWardrobe',
                                          value);
                                    })
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 29,
                                  height: 29,
                                  child: isIronedSwitchValue
                                      ? Image.asset('images/iron_on.png')
                                      : Image.asset('images/iron_off.png'),
                                ),
                                const Text(
                                  "Sudah disetrika?",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black54,
                                  ),
                                ),
                                Switch(
                                    value: isIronedSwitchValue,
                                    onChanged: (value) async {
                                      setState(() {
                                        isIronedSwitchValue = value;
                                      });

                                      await FirestoreService().editClothe(
                                          widget.uid,
                                          currentClothData['clotheId'],
                                          'isIroned',
                                          value);
                                    })
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 29,
                                  height: 29,
                                  child: isWashedSwitchValue
                                      ? Image.asset('images/wash_on.png')
                                      : Image.asset('images/wash_off.png'),
                                ),
                                const Text(
                                  "Sudah dicuci?",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black54,
                                  ),
                                ),
                                Switch(
                                    value: isWashedSwitchValue,
                                    onChanged: (value) async {
                                      setState(() {
                                        isWashedSwitchValue = value;
                                      });
                                      await FirestoreService().editClothe(
                                          widget.uid,
                                          currentClothData['clotheId'],
                                          'isWashed',
                                          value);
                                    })
                              ],
                            ),
                          ],
                        ),
                        // on off
                        mediumVerticalGap,
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Keterangan",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        ),
                        smallVerticalGap,
                        Text(
                          currentClothData['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "poppins",
                              fontSize: 10.0,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                        mediumVerticalGap,
                        SizedBox(
                            height: 54.0,
                            child: tombolPilihan("Hapus Pakaian", () async {
                              /// Setelah pakaian dihapus maka juga akan keluar detail pakaian
                              FirestoreService().deleteClothe(
                                  widget.uid, currentClothData['clotheId']);

                              /// hapus juga gambar di storage firebase
                              await FirebaseStorageLocal()
                                  .deleteFile(currentClothData['clotheId'])
                                  .then((value) => Navigator.pop(context));
                            })),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: 50.0,
                        )),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

ElevatedButton tombolPilihan(String pesan, Function tujuanDitekan) {
  return ElevatedButton(
      onPressed: () => tujuanDitekan(),
      style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: Colors.red.withOpacity(0.7))),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          )),
      child: Center(
        child: Text(
          pesan,
          style: TextStyle(
              fontFamily: "poppins",
              color: Colors.red.withOpacity(0.7),
              fontSize: 16.0,
              fontWeight: FontWeight.w500),
        ),
      ));
}
