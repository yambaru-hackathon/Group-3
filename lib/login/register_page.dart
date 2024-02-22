
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanbaru_hackathon/login/register_model.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規登録'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
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
                                labelText: 'Email',
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
                                      labelText: 'パスワード',
                                    ),
                                    onChanged: (text) {
                                      model.setPassword(text);
                                    },
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
                                  await model.signUp();
                                  Navigator.of(context).pop();
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
                              child: Text('登録する'),
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
