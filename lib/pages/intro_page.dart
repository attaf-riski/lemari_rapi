import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lemarirapi/pages/login_page.dart';
import 'package:lemarirapi/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              image: AssetImage("images/bgintro.png"), fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 288.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadiusDirectional.circular(11.0)),
                  child: const Center(
                      child: Text(
                    "Siapa lagi yang pakaiannya mau dirapiin kami?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.blue),
                  )),
                ),
                SizedBox(width: 320, child: Image.asset("images/cloud.png"))
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "Pengecekan koleksi pakaian sekarang nggak perlu ribet lihat lemari di rumah asalkan ada Lemari Rapi dari smartphone kamupun bisa!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "poppins",
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: SizedBox(
                        height: 48.0,
                        child: tombolPilihan("Login", () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        }))),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: SizedBox(
                        height: 48.0,
                        child: tombolPilihan("Register", () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return const RegisterPage();
                          // }));
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/register', (route) => false);
                        })))
              ],
            )
          ],
        ),
      ),
    ));
  }

  ElevatedButton tombolPilihan(String pesan, Function tujuanDitekan) {
    return ElevatedButton(
        onPressed: () => tujuanDitekan(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white)),
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