//ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool action1Checked = false;
bool action2Checked = false;
bool action3Checked = false;
bool action4Checked = false;

//homeページ
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SpeechBalloon(
                      nipLocation: NipLocation.bottom,
                      borderColor: const Color.fromARGB(255, 255, 255, 255),
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.6,
                      borderRadius: 8.0,
                      child: const Center(
                        child: Text(
                          '遊びに行きますか？',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'lib/images/napi.png',
                        height: MediaQuery.of(context).size.height * 0.5,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.touch_app_outlined,
                        color: Colors.grey,
                      ),
                      label: const Text(
                        'ルートをシミュレーション',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        // 位置情報の権限を確認
                        LocationPermission permission =
                            await Geolocator.checkPermission();

                        if (permission == LocationPermission.denied) {
                          // 権限がまだ求められていない場合、権限を要求
                          permission = await Geolocator.requestPermission();
                        }

                        if (permission == LocationPermission.whileInUse ||
                            permission == LocationPermission.always) {
                          // 権限が許可された場合の処理
                          User? user = _auth.currentUser;

                          if (user != null) {
                            await _firestore
                                .collection('user_data')
                                .doc(user.uid)
                                .set({
                              '1destination1': '',
                              '1destination2': '',
                              '1destination3': '',
                              '1destination4': '',
                              '2status_Eat': false,
                              '2status_WatchView': false,
                              '2status_GoStore': false,
                              '2status_None': true,
                              '3foodType': '',
                              '4foodStore': '',
                              '5viewType': '',
                              '6viewLocation': '',
                              '7storeType': '',
                              '8storeLocation': '',
                              'VisitLocation': [],
                            });
                          }
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SelectLocationPage(),
                              transitionDuration: const Duration(
                                  milliseconds: 0), // アニメーションの速度を0にする
                            ),
                          );
                        } else {
                          // 権限が拒否された場合の処理
                          // ユーザーに権限が必要である旨を通知するなどの処理を追加
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('警告'),
                                content:
                                    const Text('サービスを利用するには位置情報の取得を許可してください。'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//目的地入力
class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final TextEditingController _textFieldController3 = TextEditingController();
  final TextEditingController _textFieldController4 = TextEditingController();
  String _inputText1 = '';
  String _inputText2 = '';
  String _inputText3 = '';
  String _inputText4 = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ソフトキーボード表示時に画面をリサイズする
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        'どこに行きますか？',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi.png',
                      height: MediaQuery.of(context).size.height *
                          0.35, // 画面サイズに合わせて調整
                    ),
                  ),
                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        0.04), // 画面サイズに合わせて調整
                    child: Container(
                      decoration: BoxDecoration(
                        // color: const Color(0xffaaccff),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textFieldController1,
                              decoration: InputDecoration(
                                hintText: '目的地1を入力',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.025),
                            TextField(
                              controller: _textFieldController2,
                              decoration: InputDecoration(
                                hintText: '目的地2を入力',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.025),
                            TextField(
                              controller: _textFieldController3,
                              decoration: InputDecoration(
                                hintText: '目的地3を入力',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.025),
                            TextField(
                              controller: _textFieldController4,
                              decoration: InputDecoration(
                                hintText: '目的地4を入力',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // ホーム画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffd32929),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // 縁を丸くする半径
                            ),
                            shadowColor: Colors.black),
                        child: const Text(
                          'やめる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (_textFieldController1.text == '' &&
                              _textFieldController2.text == '' &&
                              _textFieldController3.text == '' &&
                              _textFieldController4.text == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('警告'),
                                  content: const Text('目的地を最低でも1つ入力してください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              //入力した文字列を格納
                              _inputText1 = _textFieldController1.text;
                              _inputText2 = _textFieldController2.text;
                              _inputText3 = _textFieldController3.text;
                              _inputText4 = _textFieldController4.text;
                            });

                            await _writeToFirestore(); //firestoreに目的地保存
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const BeforeGoPage(),
                                transitionDuration: const Duration(
                                    milliseconds: 0), // アニメーションの速度を0にする
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '1destination1': _inputText1,
      '1destination2': _inputText2,
      '1destination3': _inputText3,
      '1destination4': _inputText4,
      // 他のデータも同様に続く
    });
  }

  @override
  void dispose() {
    _textFieldController1.dispose(); // ウィジェットが破棄されるときにコントローラも破棄
    _textFieldController2.dispose();
    _textFieldController3.dispose();
    _textFieldController4.dispose();
    super.dispose();
  }
}

//目的地行くまでにしたいこと選択
class BeforeGoPage extends StatefulWidget {
  const BeforeGoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BeforeGoPageState createState() => _BeforeGoPageState();
}

class _BeforeGoPageState extends State<BeforeGoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        '目的地までにしたいことは？',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_guruguru.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.0352),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border:
                            Border.all(color: Colors.blue[300]!, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.0235),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: const Text('食事'),
                              value: action1Checked,
                              onChanged: (value) {
                                setState(() {
                                  action1Checked = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('景色を見る'),
                              value: action2Checked,
                              onChanged: (value) {
                                setState(() {
                                  action2Checked = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('買い物'),
                              value: action3Checked,
                              onChanged: (value) {
                                setState(() {
                                  action3Checked = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('ない'),
                              value: action4Checked,
                              onChanged: (value) {
                                setState(() {
                                  action4Checked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // ホーム画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (action1Checked == false &&
                              action2Checked == false &&
                              action3Checked == false &&
                              action4Checked == false) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('警告'),
                                  content: const Text(
                                      '目的地へ移動中にすることを最低でも1つ入力してください。\nすることがないときは「ない」を選択してください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // ボタンが押された時にFirestoreにデータを書き込む処理
                            await _writeToFirestore();
                            if (action1Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectFoodPage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action2Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectViewPage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action3Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectStorePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            }
                            if (action4Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    if (user != null) {
      // ユーザーごとにデータをFirestoreに書き込む
      await _firestore.collection('user_data').doc(user.uid).update({
        '2status_Eat': action1Checked,
        '2status_WatchView': action2Checked,
        '2status_GoStore': action3Checked,
        '2status_None': action4Checked,
      });
    }
  }
}

//ご飯の種類を選択
class SelectFoodPage extends StatefulWidget {
  const SelectFoodPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectFoodPageState createState() => _SelectFoodPageState();
}

class _SelectFoodPageState extends State<SelectFoodPage> {
  //firestoreのユーザー情報の取得
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //テキストボックスのコントローラー
  final TextEditingController _textFieldController = TextEditingController();
  //入力したものを格納する
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        'ご飯は何が食べたい？',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_kirakira.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                hintText: '例：お寿司',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.0725,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // ホーム画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (_textFieldController.text == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('警告'),
                                  content: const Text('食べたい食べ物の種類を打ち込んでください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              _inputText = _textFieldController.text;
                            });
                            await _writeToFirestore(); //firestoreに食べたいもの保存
                            if (action2Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectViewPage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action3Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectStorePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action4Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに更新
    await _firestore.collection('user_data').doc(user?.uid).update({
      '3foodType': _inputText,
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose(); // ウィジェットが破棄されるときにコントローラも破棄
    super.dispose();
  }
}

//ご飯のお店を選択
class SelectFoodExPage extends StatefulWidget {
  const SelectFoodExPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectFoodPageExState createState() => _SelectFoodPageExState();
}

class _SelectFoodPageExState extends State<SelectFoodExPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: non_constant_identifier_names
  String selectedValue_foodEx = '読み込み中…';
  // ignore: non_constant_identifier_names
  String selectedValue_foodEx_sub = '読み込み中…';
  // ignore: non_constant_identifier_names
  List<String> dropdownItems_foodEx = ['読み込み中…'];
  String? foodType = '';
  String? viewType = '';
  String? storeType = '';

  @override
  void initState() {
    super.initState();

    _searchAndSave(); // ページ読み込み時にサーチして結果を更新
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        'ご飯を食べるお店を選んでね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border:
                            Border.all(color: Colors.blue[300]!, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              value: selectedValue_foodEx,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue_foodEx = newValue!;
                                });
                              },
                              items: dropdownItems_foodEx
                                  .toSet() // 重複を排除
                                  .toList() // リストに戻す
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // ホーム画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          // Google Maps APIを使用して検索し、結果を保存
                          await _writeToFirestore();
                          if (action2Checked) {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SelectViewExPage(),
                                transitionDuration:
                                    const Duration(milliseconds: 0),
                              ),
                            );
                          } else if (action3Checked) {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SelectStoreExPage(),
                                transitionDuration:
                                    const Duration(milliseconds: 0),
                              ),
                            );
                          } else if (action4Checked) {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ShowRoutePage(),
                                transitionDuration:
                                    const Duration(milliseconds: 0),
                              ),
                            );
                          } else {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ShowRoutePage(),
                                transitionDuration:
                                    const Duration(milliseconds: 0),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _searchAndSave() async {
    try {
      foodType = await _getFoodTypeFromFirestore();
      if (foodType == null) {
        return;
      }

      viewType = await _getViewTypeFromFirestore();
      if (viewType == null) {
        return;
      }

      storeType = await _getStoreTypeFromFirestore();
      if (storeType == null) {
        return;
      }

      List<String> visitLocations = await _getVisitLocationsFromFirestore();
      String location = _getLocationForSearch(visitLocations);

      // VisitLocationからfoodTypeを含む文字列を検索
      String? selectedValuePrevious = visitLocations.firstWhere(
        (element) => element.contains(foodType!),
        orElse: () => '',
      );

      setState(() {
        selectedValue_foodEx_sub = selectedValue_foodEx;
        selectedValue_foodEx_sub = selectedValuePrevious;
        // selectedValue_foodEx = selectedValuePrevious;
      });

      List<String> searchResults =
          await searchPlaces(selectedValue_foodEx_sub, location);

      setState(() {
        dropdownItems_foodEx = searchResults.toList();
        if (dropdownItems_foodEx.isNotEmpty) {
          selectedValue_foodEx = dropdownItems_foodEx[0];
        }
      });
    } catch (e) {
      print('Error in _searchAndSave: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
    }
  }

  Future<String?> _getFoodTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 3foodTypeの値を取得して返す
        return snapshot.get('3foodType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<String?> _getViewTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 5viewTypeの値を取得して返す
        return snapshot.get('5viewType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<String?> _getStoreTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 5viewTypeの値を取得して返す
        return snapshot.get('7storeType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<List<String>> _getVisitLocationsFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // VisitLocationをリストとして返す
        return List<String>.from(snapshot.get('VisitLocation'));
      } else {
        return [];
      }
    } catch (e) {
      print('Error in _getVisitLocationsFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return [];
    }
  }

  String? _getPreviousElement(String location, List<String> visitLocations) {
    int index = visitLocations.indexOf(location);
    if (index >= 1) {
      // その前の要素が、viewTypeでない&&storeTypeでない
      if (index - 1 >= 0 && // インデックスがマイナスにならないようにチェック
          visitLocations[index - 1] != '$viewTypeを見る' &&
          visitLocations[index - 1] != '$storeTypeに行く') {
        return visitLocations[index - 1];
      }
      // その前の前の要素が、viewTypeでない&&storeTypeでない
      else if (index - 2 >= 0 && // インデックスがマイナスにならないようにチェック
          visitLocations[index - 2] != '$viewTypeを見る' &&
          visitLocations[index - 2] != '$storeTypeに行く') {
        return visitLocations[index - 2];
      }
      // その前の前の前の要素が、viewTypeでない&&storeTypeでない
      else if (index - 3 >= 0 && // インデックスがマイナスにならないようにチェック
          visitLocations[index - 3] != '$viewTypeを見る' &&
          visitLocations[index - 3] != '$storeTypeに行く') {
        return visitLocations[index - 3];
      } else {
        return null;
      }
    }
    return null;
  }

  String _getLocationForSearch(List<String> visitLocations) {
    String location = '現在地'; // デフォルトは'現在地'

    // VisitLocationの中でVisitLocationのいずれかを含む要素の一つ前の要素を取得
    String? selectedValuePrevious =
        _getPreviousElement('$foodTypeを食べる', visitLocations);

    if (selectedValuePrevious != null) {
      location = selectedValuePrevious;
    }

    return location;
  }

  Future<void> _writeToFirestore() async {
    try {
      User? user = _auth.currentUser;

      await _firestore.collection('user_data').doc(user?.uid).update({
        '4foodStore': selectedValue_foodEx,
      });
    } catch (e) {
      print('Error in _writeToFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
    }
  }

  Future<List<String>> searchPlaces(String foodType, String location) async {
    try {
      // 住所から緯度経度を取得
      List<double> coordinates = await getLocationCoordinates(location);

      if (coordinates.isEmpty) {
        // 緯度経度が取得できない場合のエラー処理
        print('Error in searchPlaces: Failed to get coordinates for location');
        return [];
      }

      String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
      String endpoint =
          'https://maps.googleapis.com/maps/api/place/textsearch/json';

      // UriクラスのqueryParametersを使用してクエリパラメータを指定
      Uri uri = Uri.parse(endpoint).replace(queryParameters: {
        'language': 'ja',
        'query': foodType,
        'location': '${coordinates[0]},${coordinates[1]}', // 緯度経度を指定
        // 'radius': '500',
        'key': apiKey,
      });

      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> results = List<String>.from(
          json.decode(response.body)['results'].map((result) => result['name']),
        );

        results = results.take(10).toList();
        return results;
      } else {
        print('Error in searchPlaces: Status Code ${response.statusCode}');
        // エラーが発生した場合の処理を追加
        // 例: エラーダイアログを表示するなど
        return [];
      }
    } catch (e) {
      print('Error in searchPlaces: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return [];
    }
  }

  Future<List<double>> getLocationCoordinates(String location) async {
    try {
      if (location == '現在地') {
        // 位置情報の取得
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double lat = position.latitude;
        double lng = position.longitude;

        return [lat, lng];
      } else {
        String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json';

        Uri uri = Uri.parse(endpoint).replace(queryParameters: {
          'address': location,
          'key': apiKey,
        });

        http.Response response = await http.get(uri);

        if (response.statusCode == 200) {
          Map<String, dynamic> result = json.decode(response.body);
          if (result['status'] == 'OK' && result['results'].isNotEmpty) {
            double lat = result['results'][0]['geometry']['location']['lat'];
            double lng = result['results'][0]['geometry']['location']['lng'];
            return [lat, lng];
          }
        }

        return [];
      }
    } catch (e) {
      print('Error in getLocationCoordinates: $e');
      return [];
    }
  }
}

//景色の種類選択
class SelectViewPage extends StatefulWidget {
  const SelectViewPage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _SelectViewPageState createState() => _SelectViewPageState();
}

class _SelectViewPageState extends State<SelectViewPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _textFieldController = TextEditingController();
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        'どんな景色を見たい？',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_guruguru.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                hintText: '例：ビーチ',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.0725,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // ホーム画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (_textFieldController.text == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('警告'),
                                  content: const Text('見たい景色の種類を打ち込んでください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              //入力した文字列を格納
                              _inputText = _textFieldController.text;
                            });
                            await _writeToFirestore(); //firestoreに見る景色の種類を書き込み
                            if (action3Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectStorePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action4Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '5viewType': _inputText,
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose(); // ウィジェットが破棄されるときにコントローラも破棄
    super.dispose();
  }
}

//景色を見る場所の選択
class SelectViewExPage extends StatefulWidget {
  const SelectViewExPage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _SelectViewExPageState createState() => _SelectViewExPageState();
}

class _SelectViewExPageState extends State<SelectViewExPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// ignore: non_constant_identifier_names
  String selectedValue_viewEx = '読み込み中…';
  // ignore: non_constant_identifier_names
  String selectedValue_viewEx_sub = '読み込み中…';
// ignore: non_constant_identifier_names
  List<String> dropdownItems_viewEx = ['読み込み中…'];

  String? foodType = '';
  String? viewType = '';
  String? storeType = '';

  @override
  void initState() {
    super.initState();
    _searchAndSave(); // ページ読み込み時にサーチして結果を更新
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        '景色を見る場所を選んでね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_think.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border:
                            Border.all(color: Colors.blue[300]!, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              value: selectedValue_viewEx,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue_viewEx = newValue!;
                                });
                              },
                              items: dropdownItems_viewEx
                                  .toSet() // 重複を排除
                                  .toList() // リストに戻す
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // ホーム画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await _writeToFirestore();
                          if (action3Checked) {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SelectStoreExPage(),
                                transitionDuration: const Duration(
                                    milliseconds: 0), // アニメーションの速度を0にする
                              ),
                            );
                          } else if (action4Checked) {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ShowRoutePage(),
                                transitionDuration: const Duration(
                                    milliseconds: 0), // アニメーションの速度を0にする
                              ),
                            );
                          } else {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ShowRoutePage(),
                                transitionDuration: const Duration(
                                    milliseconds: 0), // アニメーションの速度を0にする
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _searchAndSave() async {
    try {
      foodType = await _getFoodTypeFromFirestore();
      if (foodType == null) {
        return;
      }

      viewType = await _getViewTypeFromFirestore();
      if (viewType == null) {
        return;
      }

      storeType = await _getStoreTypeFromFirestore();
      if (storeType == null) {
        return;
      }

      List<String> visitLocations = await _getVisitLocationsFromFirestore();
      String location = _getLocationForSearch(visitLocations);

      // VisitLocationからviewTypeを含む文字列を検索
      String? selectedValuePrevious = visitLocations.firstWhere(
        (element) => element.contains(viewType!),
        orElse: () => '',
      );

      setState(() {
        selectedValue_viewEx_sub = selectedValue_viewEx;
        selectedValue_viewEx_sub = selectedValuePrevious;
        // selectedValue_viewEx = selectedValuePrevious;
      });

      List<String> searchResults =
          await searchPlaces(selectedValue_viewEx_sub, location);

      setState(() {
        dropdownItems_viewEx = searchResults.toList();
        if (dropdownItems_viewEx.isNotEmpty) {
          selectedValue_viewEx = dropdownItems_viewEx[0];
        }
      });
    } catch (e) {
      print('Error in _searchAndSave: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
    }
  }

  Future<String?> _getFoodTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 3foodTypeの値を取得して返す
        return snapshot.get('3foodType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<String?> _getViewTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 5viewTypeの値を取得して返す
        return snapshot.get('5viewType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<String?> _getStoreTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 7storeTypeの値を取得して返す
        return snapshot.get('7storeType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<List<String>> _getVisitLocationsFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // VisitLocationをリストとして返す
        return List<String>.from(snapshot.get('VisitLocation'));
      } else {
        return [];
      }
    } catch (e) {
      print('Error in _getVisitLocationsFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return [];
    }
  }

  String? _getPreviousElement(String location, List<String> visitLocations) {
    int index = visitLocations.indexOf(location);
    if (index >= 1) {
      // その前の要素が、foodTypeでない&&storeTypeでない
      if (index - 1 >= 0 && // インデックスがマイナスにならないようにチェック
          visitLocations[index - 1] != '$foodTypeを食べる' &&
          visitLocations[index - 1] != '$storeTypeに行く') {
        return visitLocations[index - 1];
      }
      // その前の前の要素が、foodTypeでない&&storeTypeでない
      else if (index - 2 >= 0 && // インデックスがマイナスにならないようにチェック
          visitLocations[index - 2] != '$foodTypeを食べる' &&
          visitLocations[index - 2] != '$storeTypeに行く') {
        return visitLocations[index - 2];
      }
      // その前の前の前の要素が、foodTypeでない&&storeTypeでない
      else if (index - 3 >= 0 && // インデックスがマイナスにならないようにチェック
          visitLocations[index - 3] != '$foodTypeを見る' &&
          visitLocations[index - 3] != '$storeTypeに行く') {
        return visitLocations[index - 3];
      }
    } else {
      return null;
    }
    return null;
  }

  String _getLocationForSearch(List<String> visitLocations) {
    String location = '現在地'; // デフォルトは'現在地'

    // VisitLocationの中でVisitLocationのいずれかを含む要素の一つ前の要素を取得
    String? selectedValuePrevious =
        _getPreviousElement('$viewTypeを見る', visitLocations);

    if (selectedValuePrevious != null) {
      location = selectedValuePrevious;
    }

    return location;
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '6viewLocation': selectedValue_viewEx,
    });
  }

  Future<List<String>> searchPlaces(String foodType, String location) async {
    try {
      // 住所から緯度経度を取得
      List<double> coordinates = await getLocationCoordinates(location);

      if (coordinates.isEmpty) {
        // 緯度経度が取得できない場合のエラー処理
        print('Error in searchPlaces: Failed to get coordinates for location');
        return [];
      }

      String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
      String endpoint =
          'https://maps.googleapis.com/maps/api/place/textsearch/json';

      // UriクラスのqueryParametersを使用してクエリパラメータを指定
      Uri uri = Uri.parse(endpoint).replace(queryParameters: {
        'language': 'ja',
        'query': viewType,
        'location': '${coordinates[0]},${coordinates[1]}', // 緯度経度を指定
        // 'radius': '500',
        'key': apiKey,
      });

      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> results = List<String>.from(
          json.decode(response.body)['results'].map((result) => result['name']),
        );

        results = results.take(10).toList();
        return results;
      } else {
        print('Error in searchPlaces: Status Code ${response.statusCode}');
        // エラーが発生した場合の処理を追加
        // 例: エラーダイアログを表示するなど
        return [];
      }
    } catch (e) {
      print('Error in searchPlaces: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return [];
    }
  }

  Future<List<double>> getLocationCoordinates(String location) async {
    try {
      if (location == '現在地') {
        // 位置情報の取得
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double lat = position.latitude;
        double lng = position.longitude;

        return [lat, lng];
      } else {
        String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json';

        Uri uri = Uri.parse(endpoint).replace(queryParameters: {
          'address': location,
          'key': apiKey,
        });

        http.Response response = await http.get(uri);

        if (response.statusCode == 200) {
          Map<String, dynamic> result = json.decode(response.body);
          if (result['status'] == 'OK' && result['results'].isNotEmpty) {
            double lat = result['results'][0]['geometry']['location']['lat'];
            double lng = result['results'][0]['geometry']['location']['lng'];
            return [lat, lng];
          }
        }

        return [];
      }
    } catch (e) {
      print('Error in getLocationCoordinates: $e');
      return [];
    }
  }
}

//お店の種類選択
class SelectStorePage extends StatefulWidget {
  const SelectStorePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectStorePageState createState() => _SelectStorePageState();
}

class _SelectStorePageState extends State<SelectStorePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _textFieldController = TextEditingController();
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        '買い物はどこに行く？',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                hintText: '例：コンビニ',
                                fillColor: Colors.blue[50],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.025), // パディングの調整
                                border: const OutlineInputBorder(),
                              ),
                              style:
                                  const TextStyle(fontSize: 14), // フォントサイズの指定
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.0725,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 1つ前の画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (_textFieldController.text == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('警告'),
                                  content:
                                      const Text('買い物をしたいお店の種類を打ち込んでください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              _inputText = _textFieldController.text;
                            });
                            await _writeToFirestore();
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SelectRoutePage(),
                                transitionDuration: const Duration(
                                    milliseconds: 0), // アニメーションの速度を0にする
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '7storeType': _inputText,
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose(); // ウィジェットが破棄されるときにコントローラも破棄
    super.dispose();
  }
}

//行く店舗の選択
class SelectStoreExPage extends StatefulWidget {
  const SelectStoreExPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectStoreExPageState createState() => _SelectStoreExPageState();
}

class _SelectStoreExPageState extends State<SelectStoreExPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ignore: non_constant_identifier_names
  String selectedValue_storeEx = '読み込み中…';
  // ignore: non_constant_identifier_names
  String selectedValue_storeEx_sub = '読み込み中…';
  // ignore: non_constant_identifier_names
  List<String> dropdownItems_storeEx = ['読み込み中…'];

  String? foodType = '';
  String? viewType = '';
  String? storeType = '';

  @override
  void initState() {
    super.initState();
    _searchAndSave(); // ページ読み込み時にサーチして結果を更新
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        '買い物するお店を選んでね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_guruguru.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border:
                            Border.all(color: Colors.blue[300]!, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              value: selectedValue_storeEx,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue_storeEx = newValue!;
                                });
                              },
                              items: dropdownItems_storeEx
                                  .toSet() // 重複を排除
                                  .toList() // リストに戻す
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 1つ前の画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await _writeToFirestore();
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ShowRoutePage(),
                              transitionDuration: const Duration(
                                  milliseconds: 0), // アニメーションの速度を0にする
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _searchAndSave() async {
    try {
      foodType = await _getFoodTypeFromFirestore();
      if (foodType == null) {
        return;
      }

      viewType = await _getViewTypeFromFirestore();
      if (viewType == null) {
        return;
      }

      storeType = await _getStoreTypeFromFirestore();
      if (storeType == null) {
        return;
      }

      List<String> visitLocations = await _getVisitLocationsFromFirestore();
      String location = _getLocationForSearch(visitLocations);

      // VisitLocationからfoodTypeを含む文字列を検索
      String? selectedValuePrevious = visitLocations.firstWhere(
        (element) => element.contains(storeType!),
        orElse: () => '',
      );

      setState(() {
        selectedValue_storeEx_sub = selectedValue_storeEx;
        selectedValue_storeEx_sub = selectedValuePrevious;
        // selectedValue_viewEx = selectedValuePrevious;
      });

      List<String> searchResults =
          await searchPlaces(selectedValue_storeEx_sub, location);

      setState(() {
        dropdownItems_storeEx = searchResults.toList();
        if (dropdownItems_storeEx.isNotEmpty) {
          selectedValue_storeEx = dropdownItems_storeEx[0];
        }
      });
    } catch (e) {
      print('Error in _searchAndSave: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
    }
  }

  Future<String?> _getFoodTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 3foodTypeの値を取得して返す
        return snapshot.get('3foodType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<String?> _getViewTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 5viewTypeの値を取得して返す
        return snapshot.get('5viewType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<String?> _getStoreTypeFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // 5viewTypeの値を取得して返す
        return snapshot.get('7storeType');
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFoodTypeFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return null;
    }
  }

  Future<List<String>> _getVisitLocationsFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        // VisitLocationをリストとして返す
        return List<String>.from(snapshot.get('VisitLocation'));
      } else {
        return [];
      }
    } catch (e) {
      print('Error in _getVisitLocationsFromFirestore: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return [];
    }
  }

  String? _getPreviousElement(String location, List<String> visitLocations) {
    int index = visitLocations.indexOf(location);
    if (index >= 1) {
      if (index - 1 >= 0 &&
          visitLocations[index - 1] != '$foodTypeを食べる' &&
          visitLocations[index - 1] != '$viewTypeを見る') {
        return visitLocations[index - 1];
      }
      // その前の前の要素が、foodTypeでない&&viewTypeでない
      else if (index - 2 >= 0 &&
          visitLocations[index - 2] != '$foodTypeを食べる' &&
          visitLocations[index - 2] != '$viewTypeを見る') {
        return visitLocations[index - 2];
      }
      // その前の前の前の要素が、foodTypeでない&&viewTypeでない
      else if (index - 3 >= 0 &&
          visitLocations[index - 3] != '$foodTypeを食べる' &&
          visitLocations[index - 3] != '$viewTypeを見る') {
        return visitLocations[index - 3];
      }
    } else {
      return null;
    }
    return null;
  }

  String _getLocationForSearch(List<String> visitLocations) {
    String location = '現在地'; // デフォルトは'現在地'

    // VisitLocationの中でVisitLocationのいずれかを含む要素の一つ前の要素を取得
    String? selectedValuePrevious =
        _getPreviousElement('$storeTypeに行く', visitLocations);

    if (selectedValuePrevious != null) {
      location = selectedValuePrevious;
    }

    return location;
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '8storeLocation': selectedValue_storeEx,
    });
  }

  Future<List<String>> searchPlaces(String foodType, String location) async {
    try {
      // 住所から緯度経度を取得
      List<double> coordinates = await getLocationCoordinates(location);

      if (coordinates.isEmpty) {
        // 緯度経度が取得できない場合のエラー処理
        print('Error in searchPlaces: Failed to get coordinates for location');
        return [];
      }

      String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
      String endpoint =
          'https://maps.googleapis.com/maps/api/place/textsearch/json';

      // UriクラスのqueryParametersを使用してクエリパラメータを指定
      Uri uri = Uri.parse(endpoint).replace(queryParameters: {
        'language': 'ja',
        'query': storeType,
        'location': '${coordinates[0]},${coordinates[1]}', // 緯度経度を指定
        // 'radius': '500',
        'key': apiKey,
      });

      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> results = List<String>.from(
          json.decode(response.body)['results'].map((result) => result['name']),
        );

        results = results.take(10).toList();
        return results;
      } else {
        print('Error in searchPlaces: Status Code ${response.statusCode}');
        // エラーが発生した場合の処理を追加
        // 例: エラーダイアログを表示するなど
        return [];
      }
    } catch (e) {
      print('Error in searchPlaces: $e');
      // エラーが発生した場合の処理を追加
      // 例: エラーダイアログを表示するなど
      return [];
    }
  }

  Future<List<double>> getLocationCoordinates(String location) async {
    try {
      if (location == '現在地') {
        // 位置情報の取得
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double lat = position.latitude;
        double lng = position.longitude;

        return [lat, lng];
      } else {
        String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json';

        Uri uri = Uri.parse(endpoint).replace(queryParameters: {
          'address': location,
          'key': apiKey,
        });

        http.Response response = await http.get(uri);

        if (response.statusCode == 200) {
          Map<String, dynamic> result = json.decode(response.body);
          if (result['status'] == 'OK' && result['results'].isNotEmpty) {
            double lat = result['results'][0]['geometry']['location']['lat'];
            double lng = result['results'][0]['geometry']['location']['lng'];
            return [lat, lng];
          }
        }

        return [];
      }
    } catch (e) {
      print('Error in getLocationCoordinates: $e');
      return [];
    }
  }
}

//経路の順番を選択
class SelectRoutePage extends StatefulWidget {
  const SelectRoutePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectRoutePageState createState() => _SelectRoutePageState();
}

class _SelectRoutePageState extends State<SelectRoutePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> originalItems = [];
  // ignore: non_constant_identifier_names
  List<String> dropdownItems_route = [];
  List<List<String>> selectedItemsList = [[]];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      // ログインユーザーを取得
      User? user = _auth.currentUser;

      if (user != null) {
        // Firestoreからデータを取得
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('user_data')
                .doc(user.uid)
                .get();

        // データをリストに格納
        String destination1 = snapshot['1destination1'];
        String destination2 = snapshot['1destination2'];
        String destination3 = snapshot['1destination3'];
        String destination4 = snapshot['1destination4'];
        String foodType = snapshot['3foodType'];
        String viewType = snapshot['5viewType'];
        String storeType = snapshot['7storeType'];

        // 各フィールドが空でない場合にリストに追加
        if (destination1.isNotEmpty) originalItems.add(destination1);
        if (destination2.isNotEmpty) originalItems.add(destination2);
        if (destination3.isNotEmpty) originalItems.add(destination3);
        if (destination4.isNotEmpty) originalItems.add(destination4);
        if (foodType.isNotEmpty) originalItems.add('$foodTypeを食べる');
        if (viewType.isNotEmpty) originalItems.add('$viewTypeを見る');
        if (storeType.isNotEmpty) originalItems.add('$storeTypeに行く');

        // 初期選択肢を設定
        resetDropdownItems();

        // setStateを呼び出してウィジェットを再構築
        setState(() {});
      }
    } catch (e) {
      // エラーが発生した場合、エラーメッセージをコンソールに出力
      Text('Error fetching data: $e');
    }
  }

  void resetDropdownItems() {
    dropdownItems_route = List.from(originalItems);
    selectedItemsList = List.generate(originalItems.length, (index) => []);
  }

  bool checkDropdownSelection() {
    // ドロップダウンが1つでも選択されていないかを確認
    for (int i = 0; i < dropdownItems_route.length; i++) {
      if (selectedItemsList[i].isEmpty) {
        return true; // 選択されていないドロップダウンがある場合
      }
    }
    return false; // すべてのドロップダウンが選択されている場合
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        '行く順番を選択してね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_guruguru.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border:
                            Border.all(color: Colors.blue[300]!, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            const Text(
                              '現在地',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // ドロップダウンリストを作成
                            for (int i = 0; i < dropdownItems_route.length; i++)
                              DropdownButton<String>(
                                value: selectedItemsList[i].isNotEmpty
                                    ? selectedItemsList[i].last
                                    : null,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      selectedItemsList[i].add(newValue);
                                    }
                                  });
                                },
                                items: dropdownItems_route
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            const Text(
                              'ゴール',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 1つ前の画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (checkDropdownSelection()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('警告'),
                                  content: const Text('ロケーションを回る順番を選択してください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Firestoreに選択されたアイテムを保存
                            await _writeToFirestore();
                            if (action1Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectFoodExPage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action2Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectViewExPage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action3Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SelectStoreExPage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else if (action4Checked) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const ShowRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            } else {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const ShowRoutePage(),
                                  transitionDuration: const Duration(
                                      milliseconds: 0), // アニメーションの速度を0にする
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'つぎへ',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('user_data').doc(user.uid).update({
        'VisitLocation': selectedItemsList.map((list) => list.last).toList(),
      });
    }
  }
}

//経路のデータを格納する構造体
class MapData {
  final List<LatLng> routeCoordinates;
  final List<Marker> markers;
  final List<Polyline> polylines;

  MapData({
    required this.routeCoordinates,
    required this.markers,
    required this.polylines,
  });

  Map<String, dynamic> toJson() {
    return {
      'markers': markers
          .map((marker) => {
                'markerId': marker.markerId.value,
                'info': {
                  'title': marker.infoWindow.title,
                  'snippet': marker.infoWindow.snippet,
                },
                'position': {
                  'latitude': marker.position.latitude,
                  'longitude': marker.position.longitude,
                },
              })
          .toList(),
      'polylines': polylines
          .map((polyline) => {
                'polylineId': polyline.polylineId.value,
                'color': polyline.color.value,
                'width': polyline.width,
                'points': polyline.points
                    .map((point) => {
                          'latitude': point.latitude,
                          'longitude': point.longitude,
                        })
                    .toList(),
              })
          .toList(),
      'routeCoordinates': routeCoordinates
          .map((coord) => {
                'latitude': coord.latitude,
                'longitude': coord.longitude,
              })
          .toList(),
    };
  }
}

List<MapData> mapDataList = [];

//経路の表示
class ShowRoutePage extends StatefulWidget {
  const ShowRoutePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShowRoutePageState createState() => _ShowRoutePageState();
}

class _ShowRoutePageState extends State<ShowRoutePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> visitLocations = [];
  bool isSaved = false; // ルートが保存されたかどうかを示す状態フラグ
  int counter = 1; // カウンターの初期値

  // SharedPreferencesのキー
  static const String visitLocationKey = 'VisitLocation';
  static const String dayKey = 'day';
  static const String mapDataKey = 'mapData';

  // SharedPreferencesのインスタンス
  late SharedPreferences _prefs;

  // 新たに追加したコントローラーと変数
  GoogleMapController? _googleMapController;

  // 新しいマップの表示位置を設定
  LatLng _initialCameraPosition = const LatLng(35.6895, 139.6917); // 東京タワーの座標

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _fetchRoute(); // fetchVisitLocations()はここで呼び出す
  }

  // SharedPreferencesの初期化
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // カウンターのロード
  void _loadCounter() {
    counter = _prefs.getInt('counter') ?? 0;
  }

  //firestoreから、visitLocationと、更新に必要なデータを取得
  Future<void> fetchVisitLocations() async {
    String? foodType;
    String? foodStore;
    String? viewType;
    String? viewLocation;
    String? storeType;
    String? storeLocation;

    try {
      User? user = _auth.currentUser;

      // Firestoreから、3foodType、4foodStore、5viewType、6viewLocation、7storeType、8storeLocationを取得
      foodType = await _getFromFirestore('3foodType');
      foodStore = await _getFromFirestore('4foodStore');
      viewType = await _getFromFirestore('5viewType');
      viewLocation = await _getFromFirestore('6viewLocation');
      storeType = await _getFromFirestore('7storeType');
      storeLocation = await _getFromFirestore('8storeLocation');

      // FirestoreからVisitLocationのデータを取得
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      // VisitLocationのデータが存在する場合、visitLocationsリストに格納
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic>? visitLocationData = snapshot.data()?['VisitLocation'];
        if (visitLocationData != null && visitLocationData.isNotEmpty) {
          visitLocations = visitLocationData.cast<String>().toList();

          // VisitLocationの更新
          updateVisitLocation(foodType, viewType, storeType, foodStore,
              viewLocation, storeLocation);

          // Firestoreからデータを取得した後にshowRouteOnMapメソッドを呼び出す
          // showRouteOnMap();
        }
      }

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // VisitLocationを更新するメソッド
  void updateVisitLocation(
      String? foodType,
      String? viewType,
      String? storeType,
      String? foodStore,
      String? viewLocation,
      String? storeLocation) {
    for (int i = 0; i < visitLocations.length; i++) {
      if (visitLocations[i] == '$foodTypeを食べる') {
        visitLocations[i] = foodStore!; // foodTypeが一致した場合、foodStoreを更新
      } else if (visitLocations[i] == '$viewTypeを見る') {
        visitLocations[i] = viewLocation!; // viewTypeが一致した場合、viewLocationを更新
      } else if (visitLocations[i] == '$storeTypeに行く') {
        visitLocations[i] = storeLocation!; // storeTypeが一致した場合、storeLocationを更新
      }
    }

    // FirestoreにVisitLocationのデータを更新
    User? user = _auth.currentUser;
    _firestore.collection('user_data').doc(user?.uid).update({
      'VisitLocation': visitLocations,
    });
  }

  // _getFromFirestoreメソッドを共通化して利用
  Future<String?> _getFromFirestore(String field) async {
    try {
      User? user = _auth.currentUser;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user_data').doc(user?.uid).get();

      if (snapshot.exists) {
        return snapshot.get(field);
      } else {
        return null;
      }
    } catch (e) {
      print('Error in _getFromFirestore: $e');
      return null;
    }
  }

  //ユーザーの現在地取得
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  String apiKey = 'AIzaSyCH1MLd-YWxGGFtErrfEYGHEytm1VJUEJM';
  // Google Maps Directions APIを使用してルート座標を取得するメソッド（経由地あり）
  Future<List<LatLng>> getRouteCoordinatesWithWaypoints(
    LatLng origin,
    LatLng destination,
    List<String> waypoints,
  ) async {
    List<LatLng> routeCoordinates = [];
    try {
      // ウェイポイントの座標を取得
      String waypointsString = waypoints.join('|');

      // Google Maps Directions APIを使用してルート情報を取得
      final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&waypoints=$waypointsString'
        '&key=$apiKey',
      ));

      print('Origin: ${origin.latitude},${origin.longitude}');
      print('Destination: ${destination.latitude},${destination.longitude}');
      print('Waypoints: $waypointsString');

      if (response.statusCode == 200) {
        // レスポンスからルート座標を抽出
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> routes = responseData['routes'];

        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]['legs'];
          for (var leg in legs) {
            final List<dynamic> steps = leg['steps'];
            for (var step in steps) {
              final Map<String, dynamic> startLocation = step['start_location'];
              final double startLat = startLocation['lat'];
              final double startLng = startLocation['lng'];
              routeCoordinates.add(LatLng(startLat, startLng));

              // ポリラインのエンコードされた座標を復元し、リストに追加
              String encodedPolyline = step['polyline']['points'];
              List<LatLng> decodedPolyline = _decodePolyline(encodedPolyline);
              routeCoordinates.addAll(decodedPolyline);

              final Map<String, dynamic> endLocation = step['end_location'];
              final double endLat = endLocation['lat'];
              final double endLng = endLocation['lng'];
              routeCoordinates.add(LatLng(endLat, endLng));
            }
          }
        } else {
          print(
              'Failed to fetch route coordinates. Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');
          throw Exception('Failed to fetch route coordinates');
        }
      } else {
        print(
            'Failed to fetch route coordinates. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to fetch route coordinates');
      }
    } catch (e) {
      print('Error in getRouteCoordinatesWithWaypoints: $e');
    }
    return routeCoordinates;
  }

  // APIのレスポンスで得た実際の道の座標をデコードしてポリラインで使えるように
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];

    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;

      points.add(LatLng(latitude, longitude));
    }

    return points;
  }

  bool _isMapTapped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbddff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SpeechBalloon(
                    nipLocation: NipLocation.bottom,
                    borderColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height *
                        0.06, // ディスプレイの高さの比率で指定
                    width: MediaQuery.of(context).size.width *
                        0.6, // ディスプレイの幅の比率で指定
                    borderRadius: 8.0,
                    child: const Center(
                      child: Text(
                        'なぴの考えたルートです！',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/images/napi_kirakira.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),

                  // 目的地の入力フォームなどを配置
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border:
                            Border.all(color: Colors.blue[300]!, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Column(
                          children: [
                            // 現在地
                            const Text(
                              '現在地',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.arrow_downward),
                            Text(
                              visitLocations.isNotEmpty
                                  ? visitLocations.first
                                  : '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // VisitLocationリストの表示
                            for (int i = 1; i < visitLocations.length; i++)
                              Column(
                                children: [
                                  const Icon(Icons.arrow_downward),
                                  Text(
                                    visitLocations[i],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                            // ゴール
                            const Text(
                              '（ゴール）',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.025),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Transform.translate(
                                offset: const Offset(
                                    10.0, 0.0), // 画像を右に10.0ポイント移動させる
                                child: Image.asset(
                                  'lib/images/book.png', // アニメーション対象の画像
                                  width: 300, // 画像の幅
                                )
                                    .animate(onPlay: (controller) {
                                      controller.repeat();
                                      controller.repeat();
                                    }) // アニメーションを再生する
                                    .shimmer(
                                      delay: const Duration(
                                          milliseconds:
                                              400), // アニメーションの開始までの遅延時間
                                      duration: const Duration(
                                          milliseconds: 800), // アニメーションの時間
                                    )
                                    .shake(
                                        hz: 4,
                                        curve: Curves
                                            .easeInOutCubic) // アニメーションを振動させる
                                    .scale(
                                      begin: const Offset(1, 1), // 開始時のスケール
                                      end: const Offset(1.1, 1.1), // 終了時のスケール
                                      duration: const Duration(
                                          milliseconds: 300), // アニメーションの時間
                                    )
                                    .then(
                                        delay: const Duration(
                                            milliseconds:
                                                300)) // アニメーションの後の遅延時間
                                    .scale(
                                      begin: const Offset(1, 1), // 開始時のスケール
                                      end: const Offset(
                                          1 / 1.1, 1 / 1.1), // 終了時のスケール
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20, // 下端からの距離
                            left: 35, // 左端からの距離
                            top: 10, // 上端からの距離
                            right: 0, // 右端からの距離
                            child: Image.asset(
                                'lib/images/loading.png'), // アニメーションの下に配置する画像
                          ),
                          GestureDetector(
                            onTapDown: (_) {
                              // マップがタップされたときにフラグを有効にする
                              setState(() {
                                _isMapTapped = true;
                              });
                            },
                            onTapUp: (_) {
                              // マップがタップ解除されたときにフラグを無効にする
                              setState(() {
                                _isMapTapped = false;
                              });
                            },
                            child: GoogleMap(
                              mapType: MapType.normal,
                              markers: mapDataList.isNotEmpty
                                  ? Set.from(mapDataList.last.markers)
                                  : <Marker>{},
                              polylines: mapDataList.isNotEmpty
                                  ? Set.from(mapDataList.last.polylines)
                                  : <Polyline>{},
                              onMapCreated: (controller) {
                                _googleMapController = controller;
                                _fetchRoute();
                              },
                              initialCameraPosition: CameraPosition(
                                target: _initialCameraPosition,
                                zoom: 12.0,
                              ),
                              gestureRecognizers: _isMapTapped
                                  ? <Factory<OneSequenceGestureRecognizer>>{
                                      Factory<OneSequenceGestureRecognizer>(
                                        () => EagerGestureRecognizer(),
                                      ),
                                    }
                                  : <Factory<OneSequenceGestureRecognizer>>{},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 1つ前の画面に戻る
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffd32929),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'もどる',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (isSaved) {
                            // すでに保存されている場合はダイアログを表示して処理を終了
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('保存済み'),
                                content: const Text('すでにルートが保存されています！'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return; // ここで処理を終了する
                          }

                          // 既存のデータを取得
                          _loadCounter();

                          User? user = _auth.currentUser;

                          // FirestoreからVisitLocationのデータを取得
                          DocumentSnapshot<Map<String, dynamic>> snapshot =
                              await _firestore
                                  .collection('user_data')
                                  .doc(user?.uid)
                                  .get();

                          // VisitLocationのデータが存在する場合、visitLocationsリストに格納
                          if (snapshot.exists && snapshot.data() != null) {
                            List<dynamic>? visitLocationData =
                                snapshot.data()?['VisitLocation'];
                            if (visitLocationData != null &&
                                visitLocationData.isNotEmpty) {
                              visitLocations =
                                  visitLocationData.cast<String>().toList();
                            }
                          }

                          List<String>? oldDataList = visitLocations;

                          // 新しいデータを作成
                          List<String> newMapDataList = mapDataList
                              .map((data) => json.encode(data.toJson()))
                              .toList();

                          // 既存のデータと新しいデータが一致するか確認
                          bool isDuplicate = oldDataList == newMapDataList;

                          // 新しいデータが一致しない場合
                          if (!isDuplicate) {
                            // カウンターを増やして保存
                            await _prefs.setInt('counter', counter + 1);

                            // カウンターを使用してキーを増やす
                            String currentVisitLocationKey =
                                '$visitLocationKey$counter';
                            String currentDayKey = '$dayKey$counter';
                            String currentMapDataKey = '$mapDataKey$counter';

                            // FirestoreのタイムスタンプをStringに変換して保存
                            String currentDayValue =
                                DateTime.now().toUtc().toString();

                            // データを保存

                            await _prefs.setStringList(
                                currentVisitLocationKey, oldDataList);
                            await _prefs.setString(
                                currentDayKey, currentDayValue);
                            await _prefs.setStringList(
                                currentMapDataKey, newMapDataList);

                            // デバッグ用にSharedPreferencesの内容をログに表示
                            print(
                                'SharedPreferences - $currentVisitLocationKey: ${_prefs.getStringList(currentVisitLocationKey)}');
                            print(
                                'SharedPreferences - $currentDayKey: ${_prefs.getString(currentDayKey)}');
                            print(
                                'SharedPreferences - $currentMapDataKey: ${_prefs.getStringList(currentMapDataKey)}');

                            // ルートが保存されたことをフラグで示す
                            isSaved = true;
                          }

                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('保存完了'),
                              content: const Text('ルートの保存が完了しました！'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          '保存',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1a69c6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // 縁を丸くする半径
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'ホーム',
                          style: TextStyle(color: Color(0xffffffff)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 住所から座標を取得するメソッド
  Future<LatLng> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return LatLng(location.latitude, location.longitude);
      } else {
        throw Exception('No coordinates found for the address: $address');
      }
    } catch (e) {
      print('Error in getCoordinatesFromAddress: $e');
      rethrow;
    }
  }

  // ルート全体の境界を取得するメソッド
  LatLngBounds getBounds(List<LatLng> routeCoordinates) {
    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = -double.infinity;
    double maxLng = -double.infinity;

    for (LatLng coordinate in routeCoordinates) {
      if (coordinate.latitude < minLat) minLat = coordinate.latitude;
      if (coordinate.longitude < minLng) minLng = coordinate.longitude;
      if (coordinate.latitude > maxLat) maxLat = coordinate.latitude;
      if (coordinate.longitude > maxLng) maxLng = coordinate.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  //マップ生成に必要なデータを集め、変換して格納するメソッド
  Future<void> _fetchRoute() async {
    await _getCurrentLocation();
    await fetchVisitLocations();

    List<String> waypoints =
        visitLocations.sublist(0, visitLocations.length - 1);
    List<LatLng> routeCoordinates = await getRouteCoordinatesWithWaypoints(
      _initialCameraPosition,
      await getCoordinatesFromAddress(visitLocations.last),
      waypoints,
    );

    List<Marker> markers = [
      Marker(
        markerId: const MarkerId('current_location'),
        position: _initialCameraPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(
          title: 'Current Location', // タイトル
          snippet: 'Your current location', // スニペット
        ),
      ),
    ];

    for (int i = 0; i < visitLocations.length; i++) {
      String location = visitLocations[i];
      LatLng coordinates = await getCoordinatesFromAddress(location);
      markers.add(
        Marker(
          markerId: MarkerId(location),
          position: coordinates,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: location, // タイトル
            snippet: 'Description for $location', // スニペット
          ),
        ),
      );
    }

    List<Polyline> polylines = [
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        points: routeCoordinates,
        width: 5,
      ),
    ];

    // Google Map コントローラーを使用してカメラを移動
    if (_googleMapController != null) {
      LatLngBounds bounds = getBounds(routeCoordinates);
      _googleMapController
          ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }

    // MapData インスタンスを作成してリストに追加
    mapDataList.add(MapData(
      routeCoordinates: routeCoordinates,
      markers: markers,
      polylines: polylines,
    ));

    setState(() {});
  }
}
