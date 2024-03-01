import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';

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
                      '次へ',
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
  bool action1Checked = false;
  bool action2Checked = false;
  bool action3Checked = false;
  bool action4Checked = false;

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
                    '次へ',
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
  String selectedValue = 'お米';
  List<String> dropdownItems = ['お米', '麺', 'パン', 'お肉', 'お寿司', 'ピザ'];

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
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: dropdownItems
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
                            const HomePage(),
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
                    '次へ',
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
