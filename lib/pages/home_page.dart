import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

bool action1Checked = false;
bool action2Checked = false;
bool action3Checked = false;
bool action4Checked = false;

// ignore: non_constant_identifier_names
String selectedValue_food = 'お米/丼';
// ignore: non_constant_identifier_names
List<String> dropdownItems_food = [
  'お米/丼',
  '麺',
  'パン',
  'お肉',
  'お寿司',
  'ピザ',
  'ファストフード'
];

// ignore: non_constant_identifier_names
String selectedValue_view = '海';
// ignore: non_constant_identifier_names
List<String> dropdownItems_view = ['海', '山'];

// ignore: non_constant_identifier_names
String selectedValue_viewEx = 'エメラルドビーチ';
// ignore: non_constant_identifier_names
List<String> dropdownItems_viewEx = ['エメラルドビーチ', 'シーグラスビーチ'];

// ignore: non_constant_identifier_names
String selectedValue_store = 'コンビニ';
// ignore: non_constant_identifier_names
List<String> dropdownItems_store = ['コンビニ', 'デパート', '家具屋', 'スポーツ店', '車', '服'];

// ignore: non_constant_identifier_names
String selectedValue_route = '目的地A';
// ignore: non_constant_identifier_names
List<String> dropdownItems_route = ['目的地A', '目的地B', '食事', '景色', '買い物'];

//homeページ
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Row(
            children: [
              Image.asset(
                'lib/images/napi.png',
                height: 45,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_think.png',
                height: 45,
              ),
              const Spacer(),
              const Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_guruguru.png',
                height: 45,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_kirakira.png',
                height: 45,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 2,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    const SizedBox(height: 120),
                    const SpeechBalloon(
                      nipLocation: NipLocation.bottom,
                      borderColor: Color.fromARGB(255, 255, 255, 255),
                      color: Colors.white,
                      height: 50,
                      width: 250,
                      child: Center(
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
                        height: 400,
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
                      },
                    ),
                  ])
                ],
              ),
              const Spacer(),
              Container(
                height: 2.5,
                color: Colors.black,
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
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const SpeechBalloon(
                nipLocation: NipLocation.bottom,
                borderColor: Color.fromARGB(255, 255, 255, 255),
                color: Colors.white,
                height: 50,
                width: 250,
                child: Center(
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
                  height: 300,
                ),
              ),
              // 目的地の入力フォームなどを配置
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffc5e1ff),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textFieldController1,
                          decoration: const InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14), // フォントサイズの指定
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textFieldController2,
                          decoration: const InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14), // フォントサイズの指定
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textFieldController3,
                          decoration: const InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14), // フォントサイズの指定
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _textFieldController4,
                          decoration: const InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14), // フォントサイズの指定
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
                          borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1a69c6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 2,
                color: Colors.black,
              ),
            ],
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
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),
            // 目的地の入力フォームなどを配置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
                    ),
                    shadowColor: Colors.black,
                  ),
                  child: const Text(
                    'もどる',
                    style: TextStyle(color: Color(0xffffffff)),
                  ),
                ),
                const Spacer(),

                //4択で選んだ時の分岐

                ElevatedButton(
                  onPressed: () async {
                    // ボタンが押された時にFirestoreにデータを書き込む処理
                    await _writeToFirestore();
                    if (action1Checked) {
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),

            // 目的地の入力フォームなどを配置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedValue_food,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue_food = newValue!;
                          });
                        },
                        items: dropdownItems_food
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                    await _writeToFirestore(); //firestoreに食べたいもの保存
                    if (action2Checked) {
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに更新
    await _firestore.collection('user_data').doc(user?.uid).update({
      '3foodType': selectedValue_food,
    });
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
  String selectedValue_foodEx = 'データ取れてないよ';
  // ignore: non_constant_identifier_names
  List<String> dropdownItems_foodEx = ['データ取れてないよ'];
  String? foodType = '';

  @override
  void initState() {
    super.initState();

    _searchAndSave(); // ページ読み込み時にサーチして結果を更新
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                            .map<DropdownMenuItem<String>>((String value) {
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
            const Spacer(),
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
                          transitionDuration: const Duration(milliseconds: 0),
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
                          transitionDuration: const Duration(milliseconds: 0),
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
                          transitionDuration: const Duration(milliseconds: 0),
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
                          transitionDuration: const Duration(milliseconds: 0),
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
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

      List<String> visitLocations = await _getVisitLocationsFromFirestore();
      String location = _getLocationForSearch(visitLocations);

      // VisitLocationからfoodTypeを含む文字列を検索
      String? selectedValuePrevious = visitLocations.firstWhere(
        (element) => element.contains(foodType!),
        orElse: () => '',
      );

      setState(() {
        selectedValue_foodEx = selectedValuePrevious;
      });

      List<String> searchResults =
          await searchPlaces(selectedValue_foodEx, location);

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
      return visitLocations[index - 1];
    } else {
      return null;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),

            // 目的地の入力フォームなどを配置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedValue_view,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue_view = newValue!;
                          });
                        },
                        items: dropdownItems_view
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                    await _writeToFirestore(); //firestoreに見る景色の種類を書き込み
                    if (action3Checked) {
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '5viewType': selectedValue_view,
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),

            // 目的地の入力フォームなどを配置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '6viewLocation': selectedValue_viewEx,
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),

            // 目的地の入力フォームなどを配置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedValue_store,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue_store = newValue!;
                          });
                        },
                        items: dropdownItems_store
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SelectRoutePage(),
                        transitionDuration:
                            const Duration(milliseconds: 0), // アニメーションの速度を0にする
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a69c6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '7storeType': selectedValue_store,
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const SpeechBalloon(
              nipLocation: NipLocation.bottom,
              borderColor: Color.fromARGB(255, 255, 255, 255),
              color: Colors.white,
              height: 50,
              width: 250,
              child: Center(
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
                height: 300,
              ),
            ),

            // 目的地の入力フォームなどを配置
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xffc5e1ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedValue_store,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue_store = newValue!;
                          });
                        },
                        items: dropdownItems_store
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

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
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ShowRoutePage(),
                        transitionDuration:
                            const Duration(milliseconds: 0), // アニメーションの速度を0にする
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a69c6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
            const Spacer(),
            Container(
              height: 2.5,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _writeToFirestore() async {
    // ログインユーザーを取得
    User? user = _auth.currentUser;

    // ユーザーごとにデータをFirestoreに書き込む
    await _firestore.collection('user_data').doc(user?.uid).update({
      '8storeLocation': selectedValue_store,
    });
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
        if (storeType.isNotEmpty) originalItems.add(storeType);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const SpeechBalloon(
                nipLocation: NipLocation.bottom,
                borderColor: Color.fromARGB(255, 255, 255, 255),
                color: Colors.white,
                height: 50,
                width: 250,
                child: Center(
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
                  height: 300,
                ),
              ),

              // 目的地の入力フォームなどを配置
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xffc5e1ff),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                .map<DropdownMenuItem<String>>((String value) {
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
              const SizedBox(height: 110),

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
                        borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                      // Firestoreに選択されたアイテムを保存
                      await _writeToFirestore();
                      if (action1Checked) {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
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
                        borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 2,
                color: Colors.black,
              ),
            ],
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

//経路の表示
class ShowRoutePage extends StatefulWidget {
  const ShowRoutePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShowRoutePageState createState() => _ShowRoutePageState();
}

class _ShowRoutePageState extends State<ShowRoutePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> visitLocations = [];

  @override
  void initState() {
    super.initState();
    fetchVisitLocations(); // VisitLocationデータをFirestoreから取得
  }

  Future<void> fetchVisitLocations() async {
    try {
      User? user = _auth.currentUser;
      // FirestoreからVisitLocationのデータを取得
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('user_data')
              .doc(user?.uid) // ユーザーIDに置き換える
              .get();

      // VisitLocationのデータが存在する場合、visitLocationsリストに格納
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic>? visitLocationData = snapshot.data()?['VisitLocation'];
        if (visitLocationData != null && visitLocationData.isNotEmpty) {
          visitLocations = visitLocationData.cast<String>().toList();
        }
      }

      setState(() {});
    } catch (e) {
      Text('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaaccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Row(
            children: [
              SizedBox(
                width: 72.4,
              ),
              Center(
                child: Text(
                  'Navinator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const SpeechBalloon(
                nipLocation: NipLocation.bottom,
                borderColor: Color.fromARGB(255, 255, 255, 255),
                color: Colors.white,
                height: 50,
                width: 250,
                child: Center(
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
                  height: 300,
                ),
              ),

              // 目的地の入力フォームなどを配置
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xffc5e1ff),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          visitLocations.isNotEmpty ? visitLocations.first : '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // VisitLocationリストの表示
                        for (int i = 1; i < visitLocations.length; i++)
                          Column(
                            children: [
                              const Icon(Icons.arrow_downward),
                              Text(
                                visitLocations[i],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                        // ゴール
                        const Icon(Icons.arrow_downward),
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
              const SizedBox(
                height: 110,
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
                        borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1a69c6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // 縁を丸くする半径
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
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 2.5,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
