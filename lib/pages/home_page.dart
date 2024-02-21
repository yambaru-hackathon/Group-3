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
                  onPressed: () {},
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class RaisedButton {}
