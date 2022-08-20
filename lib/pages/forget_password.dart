import 'package:flutter/material.dart';
import 'package:lemarirapi/util/jarak_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lemarirapi/services/auth.dart';

/// Jika lupa password maka bisa lewat halaman ini
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _controller = TextEditingController();

  /// seperti catatan login dan register
  String? errorMessage = '';

  Future<void> sendResetPassword() async {
    try {
      await Auth().sendResetPassword(
        email: _controller.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.blue, Colors.white])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Kelupaan Password?",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    smallVerticalGap,
                    const Text(
                      "Tenang, kami akan kirimkan link reset password ke email kamu yang telah terdaftar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    mediumVerticalGap,
                    InputLogin(
                        controller: _controller,
                        hintText: "email",
                        isPassword: false),
                    mediumVerticalGap,
                    SizedBox(
                      height: 54.0,
                      child: tombolPilihan("Kirim Link", () async {
                        /// fungsi utama
                        await sendResetPassword();
                      }),
                    ),
                  ],
                )),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 50.0,
                  )),
            ),
          ],
        ),
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
    return SizedBox(
      child: TextField(
        style: const TextStyle(
            fontFamily: "poppins", fontSize: 16.0, fontWeight: FontWeight.w500),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
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
            fillColor: Colors.white),
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
