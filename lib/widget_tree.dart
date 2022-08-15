import 'package:firebase_auth/firebase_auth.dart';
import 'package:lemarirapi/auth.dart';
import 'package:flutter/material.dart';
import 'package:lemarirapi/pages/intro_page.dart';
import 'package:lemarirapi/pages/login_page.dart';
import 'package:lemarirapi/pages/home/home_page.dart';
import 'package:lemarirapi/save_setting.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final Future<bool> _isFirstTime = SaveSetting().getFirstTimeOpenApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isFirstTime,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshotFuture) {
          return (snapshotFuture.hasData)
              ? StreamBuilder(
                  initialData: User,
                  stream: Auth().authStateChanges,
                  builder: (context, snapshotStream) {
                    if (snapshotStream.hasData) {
                      // Auth().currentUser?.emailVerified ?? true;
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
