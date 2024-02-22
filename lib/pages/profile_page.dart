import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';
import 'package:yanbaru_hackathon/login/profile.dart';

class ProfilePage extends StatelessWidget {
  
  @override
  
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileModel>(
      create: (_) => ProfileModel()..fetchUser(),
      child: Scaffold(
        backgroundColor: const Color(0xffaabbff),
        appBar: AppBar(
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
        body: Center(
          child: Consumer<ProfileModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog<void>(
                         context: context,
                         builder: (_) {
                           return AlertDialogSample();
                         });
                    },
                    icon: const Icon(Icons.logout),
                  ),
                  const CircleAvatar(
                   radius: 50,
                   backgroundImage: AssetImage('lib/user_image/icon.jpg'),
                      // ユーザーのプロフィール画像
                  ),
                  Text(model.email ?? 'メールアドレスなし'),
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
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ログアウトしますか？'),
      actions: <Widget>[
        GestureDetector(
          child: Text('いいえ'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Text('はい'),
          onTap: () async {
            try {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // ログインページに遷移した後に戻ることを禁止する
              );// ダイアログを閉じる
              
            }
            catch (e) {
              print('ログアウト中にエラーが発生しました: $e');
            }
          },
        )
      ],
    );
  }
}