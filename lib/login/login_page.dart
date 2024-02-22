import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanbaru_hackathon/login/login_model.dart';
import 'package:yanbaru_hackathon/login/register_page.dart';

import '../main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Login to Navinator',
              style: TextStyle(
                color: Color(0xffffffff),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: model.titleController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                              onChanged: (text) {
                                model.setEmail(text);
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 30),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: model.authorController,
                                    decoration: const InputDecoration(
                                      hintText: 'パスワード',
                                    ),
                                    onChanged: (text) {
                                      model.setPassword(text);
                                    },
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                model.startLoading();

                                // 追加の処理
                                try {
                                  await model.login();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        // 画面遷移したい！！！HOMEに！！！
                                        // HomePageにアクセスし、特定の処理を実行
                                        // MyApp()を起動する
                                        MyHomePage.homeKey.currentState
                                            ?.executeAfterLogin();
                                        return const MyApp();
                                      },
                                      transitionDuration: const Duration(
                                          milliseconds: 0), // アニメーションの時間を0にする
                                    ),
                                  );
                                } catch (e) {
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(e.toString()),
                                  );
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } finally {
                                  model.endLoading();
                                }
                              },
                              child: const Text('ログイン'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // 画面遷移
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: const Text('新規登録の方はこちら'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
