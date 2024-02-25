import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yanbaru_hackathon/keep/keep_map.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int numberOfData;

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
                height: 45,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_think.png',
                height: 45,
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
                height: 45,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_kirakira.png',
                height: 45,
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) {
                        return const AlertDialogSample();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle),
                      Text(
                        email ?? 'No email',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 108, 121, 189),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 64, 80, 126),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                '保存した経路',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: _fetchUserOldData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (snapshot.data!.exists) {
                                numberOfData = snapshot.data!['NumberofData'];
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 50,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 3.0,
                                    ),
                                    itemCount: numberOfData,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => KeepMap(visitLocationIndex: (numberOfData - 1) - index, lastLocation: '',)),
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 100,
                                          color: Color.fromARGB(255, 104, 125, 189),
                                          child: Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              Positioned(
                                                left: 0,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(255, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  'Item $index',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text('No item'),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      return await FirebaseFirestore.instance.collection('users').doc(uid).get();
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot> _fetchUserOldData() {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance.collection('user_old_data').doc(uid).snapshots();
    } catch (e) {
      rethrow;
    }
  }
}

class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({Key? key}) : super(key: key);

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
                (route) => false,
              );
            } catch (e) {
              Text('ログアウト中にエラーが発生しました: $e');
            }
          },
        )
      ],
    );
  }
}