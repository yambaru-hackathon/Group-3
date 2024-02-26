import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';
import 'firebase_options.dart';

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

  final double tabBarHeight = 0.08; // タブバーの高さの比率
  final double iconSize = 0.06; // アイコンのサイズの比率

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: _currentIndex),
      items: _navBarsItems(),
      screens: [
        HomePage(),
        const MapPage(),
        const ProfilePage(),
      ],

      confineInSafeArea: true, // セーフエリア内に制約をかける
      backgroundColor: Colors.white, // 背景色の指定
      handleAndroidBackButtonPress: true, // Androidの戻るボタン制御
      stateManagement: true, // ステート管理を有効にする
      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.white, // タブバーの背後の色
      ),
      popAllScreensOnTapOfSelectedTab: true, // タブ選択時にスタック内のすべてのページをポップ
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 100), // アイテムアニメーションのデュレーション
        curve: Curves.easeInOut, // アイテムアニメーションのカーブ
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true, // タブの切り替え時にアニメーションを有効にする
        curve: Curves.easeInOut, // 画面遷移アニメーションのカーブ
        duration: Duration(milliseconds: 100), // 画面遷移アニメーションのデュレーション
      ),
      navBarHeight: MediaQuery.of(context).size.height * tabBarHeight,
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
      _currentIndex = 0; // Homeタブに切り替える例
    });
  }
}
