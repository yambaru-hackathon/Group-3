import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';
import 'firebase_options.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: LoginPage(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffaaccff)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  // 追加: GlobalKeyの定義
  // ignore: library_private_types_in_public_api
  static final GlobalKey<_MyHomePageState> homeKey =
      GlobalKey<_MyHomePageState>();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorPrimary:
            Colors.blue, // 修正点: activeColor から activeColorPrimary に変更
        inactiveColorPrimary:
            Colors.grey, // 修正点: inactiveColor から inactiveColorPrimary に変更
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.map),
        title: 'Map',
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: 'Profile',
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: _currentIndex),
      items: _navBarsItems(),
      screens: const [
        HomePage(),
        MapPage(),
        ProfilePage(),
      ],
      onItemSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  void executeAfterLogin() {
    // ログイン後に実行したい処理をここに追加
    // 特定のタブに切り替えるなど
    // HomePageにする
    setState(() {
      _currentIndex = 1; // Mapタブに切り替える例
    });
  }
}
