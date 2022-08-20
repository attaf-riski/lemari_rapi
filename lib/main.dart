import 'package:flutter/material.dart';
import 'package:lemarirapi/pages/forget_password.dart';
import 'package:lemarirapi/pages/home/home_page.dart';
import 'package:lemarirapi/pages/login_page.dart';
import 'package:lemarirapi/pages/register_page.dart';
import 'package:lemarirapi/pages/send_verification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lemarirapi/widget_tree.dart';

Future<void> main() async {
  /// Karena projek ini ada firebase maka ditambah 2 baris dibawah ini
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lemari Rapi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WidgetTree(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/sendverif': (context) => const SendVerification(),
        '/forgetpassword': (context) => const ForgetPassword(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
