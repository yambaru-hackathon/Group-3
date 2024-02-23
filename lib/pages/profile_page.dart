import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yanbaru_hackathon/keep/keep_map.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               IconButton(
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (_) {
                            return const AlertDialogSample();
                          });
                    },
                    icon: const Icon(Icons.logout),
                  ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/user_image/icon.png'),
              ),
              const SizedBox(height: 20),
              FutureBuilder<DocumentSnapshot>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var email = snapshot.data!['email'];
                    return Text(
                      email ?? 'No email',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // プロフィールを編集する画面に遷移する処理を追加
                },
                child: const Text('プロフィールを編集'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _fetchUserOldData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int numberOfData = snapshot.data!['NumberofData'];
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: numberOfData,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => KeepMap(visitLocationIndex: index)),
                              );
                            },
                            child: Container(
                              color: Colors.blueGrey,
                              child: Center(
                                child: Text(
                                  'Item $index',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    try {
      // ログインユーザーのUIDを取得
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Firestoreからログインユーザーのデータを取得する
      return await FirebaseFirestore.instance.collection('users').doc(uid).get();
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot> _fetchUserOldData() {
    try {
      // ログインユーザーのUIDを取得
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Firestoreからログインユーザーの古いデータを取得するストリームを返す
      return FirebaseFirestore.instance.collection('user_old_data').doc(uid).snapshots();
    } catch (e) {
      rethrow;
    }
  }
}

class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ログアウトしますか？'),
      actions: <Widget>[
        GestureDetector(
          child: const Text('いいえ'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: const Text('はい'),
          onTap: () async {
            try {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // ログインページに遷移した後に戻ることを禁止する
              ); // ダイアログを閉じる
            } catch (e) {
              Text('ログアウト中にエラーが発生しました: $e');
            }
          },
        )
      ],
    );
  }
}
