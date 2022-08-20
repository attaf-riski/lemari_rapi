import 'package:lemarirapi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lemarirapi/pages/intro_page.dart';
import 'package:lemarirapi/pages/login_page.dart';
import 'package:lemarirapi/pages/home/home_page.dart';
import 'package:lemarirapi/save_setting.dart';

/// menggunakan akun pr8****** untuk penyimpanan firebase
/// Stateless ini bertujuan untuk mengarahkan user ke tempat yang sesuai
/// Jika belum login masuk ke login page
/// Jika sudah login masuk ke home page
/// Jika baru pertama kali masuk app masuk Intro page
/// Menggunakan shared preferences untuk penyimpanan state lokal

class WidgetTree extends StatelessWidget {
  WidgetTree({Key? key}) : super(key: key);
  final Future<bool> _isFirstTime = SaveSetting().getFirstTimeOpenApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isFirstTime,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshotFuture) {
          return (snapshotFuture.hasData)
              ? StreamBuilder(
                  stream: Auth().authStateChanges,
                  builder: (context, snapshotStream) {
                    if (snapshotStream.hasData) {
                      return const HomePage();
                    } else {
                      if (snapshotFuture.data) {
                        return const IntroPage();
                      } else {
                        return const LoginPage();
                      }
                    }
                  })
              : Scaffold(
                  body: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
        });
  }
}
