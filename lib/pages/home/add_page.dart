import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lemarirapi/model/user.dart';
import 'package:lemarirapi/services/auth.dart';
import 'package:lemarirapi/services/firebase_storage.dart';
import 'package:lemarirapi/services/firestore_services.dart';
import 'package:lemarirapi/services/imagepicker.dart';
import 'package:lemarirapi/util/jarak_widget.dart';

/// Menambahk pakaian baru
class AddClothe extends StatefulWidget {
  const AddClothe({Key? key}) : super(key: key);

  @override
  State<AddClothe> createState() => _AddClotheState();
}

class _AddClotheState extends State<AddClothe> {
  bool isAtWardrobeSwitchValue = false;
  bool isIronedSwitchValue = false;
  bool isWashedSwitchValue = false;

  Future getCurrentUser() async {
    return await Auth().getCurrentUser();
  }

  final TextEditingController _controllerClotheName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  File? image;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                mediumVerticalGap,
                SizedBox(
                  height: 186.0,
                  width: 159.0,
                  child: (image == null)
                      ? Image.asset(
                          "images/hoodie.png",
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                ),
                smallVerticalGap,
                SizedBox(
                    height: 54.0,
                    child: tombolPilihan("Pilih gambar", () async {
                      /// Mengambil gambar pakaian dari galeri
                      image = await ImagePickerLocal().pickUploudImage();

                      /// refresh
                      setState(() {});
                    })),

                smallVerticalGap,
                InputLogin(
                    controller: _controllerClotheName,
                    hintText: "Nama Pakaian",
                    isPassword: false),

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
                            onChanged: (value) {
                              setState(() {
                                isAtWardrobeSwitchValue = value;
                              });
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
                            onChanged: (value) {
                              setState(() {
                                isIronedSwitchValue = !isIronedSwitchValue;
                              });
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
                            onChanged: (value) {
                              setState(() {
                                isWashedSwitchValue = !isWashedSwitchValue;
                              });
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
                InputLogin(
                    controller: _controllerDescription,
                    hintText: "masukan keterangan pakaian",
                    isPassword: false),
                miniVerticalGap,
                SizedBox(
                    height: 54.0,
                    child: tombolPilihan("Tambah Pakaian", () async {
                      /// fungsi uploud
                      /// dapatkan dulu current user
                      UserLocal currentUser = await getCurrentUser();

                      /// id baju didapatkan dari timestap epoch saat disubmit
                      var clotheId =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      /// penyimpanan firebase storage lalu dapatkan linknya
                      var imageURL =
                          await FirebaseStorageLocal().putFile(image, clotheId);

                      /// proses uploud
                      await FirestoreService()
                          .addClothe(
                              uid: currentUser.uid!,
                              clotheName: _controllerClotheName.text,
                              clotheId: clotheId,
                              imageURL: imageURL,
                              description: _controllerDescription.text,
                              isWashed: isWashedSwitchValue,
                              isIroned: isIronedSwitchValue,
                              isAtWardrobe: isAtWardrobeSwitchValue)
                          .then((value) {
                        /// jika berhasil maka set semuanya ulang
                        setState(() {
                          image = null;
                          _controllerClotheName.text =
                              _controllerDescription.text = '';
                          isAtWardrobeSwitchValue =
                              isIronedSwitchValue = isWashedSwitchValue = false;
                        });
                      });
                    })),
                mediumVerticalGap
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InputLogin extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const InputLogin({
    required this.controller,
    required this.hintText,
    required this.isPassword,
    Key? key,
  }) : super(key: key);

  @override
  State<InputLogin> createState() => _InputLoginState();
}

class _InputLoginState extends State<InputLogin> {
  bool _obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: TextField(
            style: const TextStyle(
                fontFamily: "poppins",
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
            controller: widget.controller,
            obscureText: widget.isPassword ? _obsecureText : widget.isPassword,
            decoration: InputDecoration(
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        icon: _obsecureText
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off))
                    : const SizedBox(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                    fontFamily: "poppins",
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(11.0)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(11.0)),
                filled: true,
                fillColor: Colors.lightBlue.withOpacity(0.2)),
          ),
        ),
      ],
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
