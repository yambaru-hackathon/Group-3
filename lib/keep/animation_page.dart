import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 使用しているライブラリに応じてライブラリをインポートする

class AnimationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ローディング'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(10.0, 0.0), // 画像を右に10.0ポイント移動させる
                  child: Image.asset(
                    'lib/images/book.png',
                    width: 300,
                  )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      delay: Duration(milliseconds: 400),
                      duration: Duration(milliseconds: 800),
                    )
                    .shake(hz: 4, curve: Curves.easeInOutCubic)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: Duration(milliseconds: 300),
                    )
                    .then(delay: Duration(milliseconds: 300))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1 / 1.1, 1 / 1.1),
                    ),
                ),
              ),
            ),
            Positioned(
              bottom: 20, // 下端からの距離
              left: 35,
              top: 10,
              right: 0,
              child: Image.asset('lib/images/loading.png'), // アニメーションの下に配置する画像
            ),
          ],
        ),
      ),
    );
  }
}