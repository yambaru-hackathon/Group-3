import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 204, 255), 
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40), child: AppBar(
          title: const Center(
            child: Text(
              'Navinator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
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
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Image.asset(
                      'char_images/char_imageA.png',
                      width: 250,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.touch_app,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'ルートをシミュレーションDA',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,

                        )
                      ),
                    style: ElevatedButton.styleFrom( 
                      backgroundColor: Colors.white,
                      fixedSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {},
                  ), 
                ]
              )
          

            ],
          ),

        ),
      ),
    );
  }
}

class RaisedButton {
}
