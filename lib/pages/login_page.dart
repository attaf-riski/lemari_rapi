import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lemarirapi/util/jarak_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lemarirapi/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String? errorMessage = '';

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth()
          .signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      )
          .then((value) {
        setState(() {
          errorMessage = '';
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                    "Hai Ketemu Lagi!",
                    style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  smallVerticalGap,
                  const Text(
                    "Selamat datang kembali! Kami sudah merindukan kamu!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  smallVerticalGap,
                  InputLogin(
                    controller: _controllerEmail,
                    hintText: "username",
                    isPassword: false,
                  ),
                  smallVerticalGap,
                  InputLogin(
                    controller: _controllerPassword,
                    hintText: "password",
                    isPassword: true,
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgetpassword');
                        },
                        child: const Text(
                          "Lupa Password?",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  mediumVerticalGap,
                  SizedBox(
                      height: 54.0,
                      child: tombolPilihan("Login", () async {
                        await signInWithEmailAndPassword().then((value) {
                          if (errorMessage == '') {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          }
                        });
                      })),
                  smallVerticalGap,
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/register', (route) => false);
                      },
                      child: const Text(
                        "Belum daftar? Register Yuk!",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "poppins",
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500),
                      )),
                  smallVerticalGap,
                  Text('$errorMessage',
                      style: const TextStyle(
                          color: Colors.red,
                          fontFamily: "poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500))
                ],
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
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
