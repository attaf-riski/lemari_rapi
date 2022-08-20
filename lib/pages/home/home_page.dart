import 'package:flutter/material.dart';
import 'package:lemarirapi/pages/home/add_page.dart';
import 'package:lemarirapi/pages/home/profile_page.dart';
import 'package:lemarirapi/pages/home/wardrobe_page.dart';

/// Halaman ini berfungsi sebagai wadah utama bottom navigator
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  /// list halaman untuk berpindah
  final List<Widget> _pages = <Widget>[
    const WardrobePage(),
    const AddClothe(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lemari Rapi"),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          backgroundColor: Colors.blue,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          selectedFontSize: 14.0,
          selectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(
              fontFamily: "poppins", fontSize: 14.0, color: Colors.white),
          onTap: onTapEvent,
          currentIndex: currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.square),
              label: "Lemari",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo),
              label: "Tambah",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
            )
          ]),
    );
  }

// mengganti nilai currentIndex dengan value yang disentuh user
  void onTapEvent(int value) {
    setState(() {
      currentIndex = value;
    });
  }
}
