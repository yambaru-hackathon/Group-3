
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanbaru_hackathon/login/login_model.dart';
import 'package:yanbaru_hackathon/login/register_page.dart';
import 'package:yanbaru_hackathon/pages/home_page.dart';



class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
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
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                              onChanged: (text) {
                                model.setEmail(text);
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: model.authorController,
                                    decoration: InputDecoration(
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
                            SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                model.startLoading();
                      
                                // 追加の処理
                                try {
                                  await model.login();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(), // 画面遷移したい！！！HOMEに！！
                                    ),
                                  );
                                } catch (e) {
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(e.toString()),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } finally {
                                  model.endLoading();
                                }
                              },
                              child: Text('ログイン'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // 画面遷移
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Text('新規登録の方はこちら'),
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
                    child: Center(
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
