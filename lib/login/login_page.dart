import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanbaru_hackathon/login/login_model.dart';
import 'package:yanbaru_hackathon/login/register_page.dart';

import '../main.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ログイン状態の確認中はローディング表示を行う
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // ログイン済みの場合はホーム画面に遷移する
          if (snapshot.data != null) {
            MyHomePage.homeKey.currentState?.executeAfterLogin();
            return const MyApp(); // ログイン済みなのでMyAppに遷移
          } else {
            // 未ログインの場合はログイン画面を表示する
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
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
                                          Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) {
                                                MyHomePage.homeKey.currentState?.executeAfterLogin();
                                                return const MyApp(); // ログイン後はMyAppに遷移
                                              },
                                              transitionDuration: const Duration(milliseconds: 0),
                                            ),
                                          );
                                        } catch (e) {
                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(e.toString()),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      },
    );
  }
}