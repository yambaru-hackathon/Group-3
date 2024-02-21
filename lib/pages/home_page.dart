import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';

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
                height: 50,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_think.png',
                height: 50,
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
                height: 50,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_kirakira.png',
                height: 50,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Row(
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
                    color: Colors.black,
                  ),
                  label: const Text('ルートをシミュレーション',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SelectLocationPage(),
                        transitionDuration:
                            const Duration(milliseconds: 0), // アニメーションの速度を0にする
                      ),
                    );
                  },
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class SelectLocationPage extends StatelessWidget {
  SelectLocationPage({super.key});

  final TextEditingController _textController = TextEditingController();

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
                width: 70,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 目的地の入力フォームなどを配置
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'テキストを入力してください',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // ホーム画面に戻る
                    },
                    child: const Text('やめる'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const HomePage(),
                          transitionDuration: const Duration(
                              milliseconds: 0), // アニメーションの速度を0にする
                        ),
                      );
                    },
                    child: const Text('次へ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
