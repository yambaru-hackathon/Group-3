import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';

bool action1Checked = false;
bool action2Checked = false;
bool action3Checked = false;
bool action4Checked = false;

// ignore: non_constant_identifier_names
String selectedValue_food = 'お米';
// ignore: non_constant_identifier_names
List<String> dropdownItems_food = ['お米', '麺', 'パン', 'お肉', 'お寿司', 'ピザ'];

// ignore: non_constant_identifier_names
String selectedValue_foodEx = 'くら寿司';
// ignore: non_constant_identifier_names
List<String> dropdownItems_foodEx = ['くら寿司', 'はま寿司', 'かっぱ寿司', 'スシロー'];

// ignore: non_constant_identifier_names
String selectedValue_view = '海';
// ignore: non_constant_identifier_names
List<String> dropdownItems_view = ['海', '山'];

// ignore: non_constant_identifier_names
String selectedValue_viewEx = 'エメラルドビーチ';
// ignore: non_constant_identifier_names
List<String> dropdownItems_viewEx = ['エメラルドビーチ', 'シーグラスビーチ'];

// ignore: non_constant_identifier_names
String selectedValue_store = 'ファミリーマート';
// ignore: non_constant_identifier_names
List<String> dropdownItems_store = ['ファミリーマート', '麺', 'パン', 'お肉', 'お寿司', 'ピザ'];

// ignore: non_constant_identifier_names
String selectedValue_route = '目的地A';
// ignore: non_constant_identifier_names
List<String> dropdownItems_route = ['目的地A', '目的地B', '食事', '景色', '買い物'];

//homeページ
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                      onPressed: () {
                        Navigator.push(
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
class SelectLocationPage extends StatelessWidget {
  const SelectLocationPage({super.key});

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
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 14), // フォントサイズの指定
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 14), // フォントサイズの指定
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 14), // フォントサイズの指定
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter text',
                            contentPadding: EdgeInsets.all(10), // パディングの調整
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 14), // フォントサイズの指定
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
                    onPressed: () {
                      Navigator.push(
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
}

//目的地行くまでにしたいこと選択
class BeforeGoPage extends StatefulWidget {
  const BeforeGoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BeforeGoPageState createState() => _BeforeGoPageState();
}

class _BeforeGoPageState extends State<BeforeGoPage> {
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
                  onPressed: () {
                    if (action1Checked) {
                      Navigator.push(
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
}

//ご飯の種類を選択
class SelectFoodPage extends StatefulWidget {
  const SelectFoodPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectFoodPageState createState() => _SelectFoodPageState();
}

class _SelectFoodPageState extends State<SelectFoodPage> {
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

                //4択で選んだ時の分岐

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SelectFoodExPage(),
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
}

//ご飯のお店を選択
class SelectFoodExPage extends StatefulWidget {
  const SelectFoodExPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectFoodPageExState createState() => _SelectFoodPageExState();
}

class _SelectFoodPageExState extends State<SelectFoodExPage> {
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
                  'お店を選んでね',
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

                //4択で選んだ時の分岐

                ElevatedButton(
                  onPressed: () {
                    if (action2Checked) {
                      Navigator.push(
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
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SelectStorePage(),
                          transitionDuration: const Duration(
                              milliseconds: 0), // アニメーションの速度を0にする
                        ),
                      );
                    } else {
                      Navigator.push(
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
}

//景色の種類選択
class SelectViewPage extends StatefulWidget {
  const SelectViewPage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _SelectViewPageState createState() => _SelectViewPageState();
}

class _SelectViewPageState extends State<SelectViewPage> {
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SelectViewExPage(),
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
}

//景色を見る場所の選択
class SelectViewExPage extends StatefulWidget {
  const SelectViewExPage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _SelectViewExPageState createState() => _SelectViewExPageState();
}

class _SelectViewExPageState extends State<SelectViewExPage> {
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
                  '見る場所を選んでね',
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

                //4択で選んだ時の分岐

                ElevatedButton(
                  onPressed: () {
                    if (action3Checked) {
                      Navigator.push(
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
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SelectStorePage(),
                          transitionDuration: const Duration(
                              milliseconds: 0), // アニメーションの速度を0にする
                        ),
                      );
                    } else {
                      Navigator.push(
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
}

//お店の選択
class SelectStorePage extends StatefulWidget {
  const SelectStorePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectStorePageState createState() => _SelectStorePageState();
}

class _SelectStorePageState extends State<SelectStorePage> {
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

                //4択で選んだ時の分岐

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
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
}

//経路の順番を選択
class SelectRoutePage extends StatefulWidget {
  const SelectRoutePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectRoutePageState createState() => _SelectRoutePageState();
}

class _SelectRoutePageState extends State<SelectRoutePage> {
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
                  width: 200,
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
                        DropdownButton<String>(
                          value: selectedValue_route,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue_route = newValue!;
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
                        DropdownButton<String>(
                          value: selectedValue_route,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue_route = newValue!;
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
                        DropdownButton<String>(
                          value: selectedValue_route,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue_route = newValue!;
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
                        DropdownButton<String>(
                          value: selectedValue_route,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue_route = newValue!;
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
                        DropdownButton<String>(
                          value: selectedValue_route,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue_route = newValue!;
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
              const SizedBox(height: 30),

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
                      Navigator.push(
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
}

//経路の表示
class ShowRoutePage extends StatefulWidget {
  const ShowRoutePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShowRoutePageState createState() => _ShowRoutePageState();
}

class _ShowRoutePageState extends State<ShowRoutePage> {
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

                //4択で選んだ時の分岐

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
}
