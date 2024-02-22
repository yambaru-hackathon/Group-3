import 'package:flutter/material.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffaabbff),
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
      body:
       Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                   onPressed: () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                      // ボタンが押された時の処理をここに記述
                     },
                   icon: const Icon(Icons.person),
              ),
            
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://example.com/user_profile_image.jpg'),
               // ユーザーのプロフィール画像
              ),
              
              const SizedBox(height: 20),
              const Text(
                'ユーザー名',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'user@example.com',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // プロフィールを編集する画面に遷移する処理を追加
                },
                child: const Text('プロフィールを編集'),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(6, (index) {
                      return Container(
                        color: Colors.blueGrey,
                        child: Center(
                          child: Text(
                            'Item $index',
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      );
                    }),
                  )
              )
              
            ],
          ),
        ),
    );
  }
}
