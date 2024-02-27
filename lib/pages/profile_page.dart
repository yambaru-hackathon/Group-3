// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yanbaru_hackathon/keep/keep_map.dart';
import 'package:yanbaru_hackathon/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int numberOfData;
  bool _isDeleting = false;

  Future<List<String>> fetchImages(String apiKey, String searchQuery) async {
    String baseUrl = 'https://pixabay.com/api/';
    String query = Uri.encodeComponent(searchQuery);
    String url = '$baseUrl?key=$apiKey&q=$query';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> imageUrls = [];
        for (var item in data['hits']) {
          imageUrls.add(item['webformatURL']);
        }
        return imageUrls;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error sending request: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8CC6F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: FractionallySizedBox(
            widthFactor: 1.0,
            child: Row(
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
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 10),
            FutureBuilder<DocumentSnapshot>(
              future: _fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var email = snapshot.data!['email'];
                  var emailParts = email.split('@'); // ＠でメールアドレスを分割する
                  var displayEmail = emailParts.isNotEmpty ? emailParts[0] : 'No email'; // ＠の前の部分を表示する
                  return Column(
                    children: [
                      const Icon(Icons.account_circle, size: 80, color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayEmail, // ＠の前の部分を表示する
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                    ],
                  );
                }
              },
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        '保存した経路',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
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
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3.0,
                                  ),
                                  itemCount: numberOfData,
                                  itemBuilder: (context, index) {
                                    final visitLocationData = snapshot.data!['VisitLocation${numberOfData - index}'];
                                    final visitLocationText = visitLocationData != null ? visitLocationData.join(", ") : 'No visit location';
                                    final lastLocation = visitLocationText.split(',').last.trim(); 
                                    final timeStamp = snapshot.data!['day${numberOfData - index}'] as Timestamp;
                                    final dateTime = timeStamp.toDate();
                                    final formattedDate = '${dateTime.year}/${dateTime.month}/${dateTime.day}'; 
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => KeepMap(visitLocationIndex: (numberOfData - 1) - index, lastLocation: ''),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4E8AC9),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x95949480), //0xff95949480
                                              spreadRadius: 5,
                                              blurRadius: 4,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    lastLocation,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: _isDeleting
                                                  ? const CircularProgressIndicator()
                                                  : IconButton(
                                                      onPressed: () {
                                                        _confirmDeleteDialog(context, numberOfData - index);
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 50, // 画像を左側に配置する場合
                                              child: FutureBuilder<List<String>>(
                                                future: fetchImages('42571096-8e282fb7693d928411cb5d713',lastLocation), // 画像を取得する関数を呼び出す
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  } else {
                                                    // 画像を表示する
                                                    return Image.network(
                                                      snapshot.data![index], // 画像のURL
                                                      width: 200,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    );
                                                  }
                                                },
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

  Future<void> _deleteVisitLocationData(BuildContext context, int index) async {
    try {
      setState(() {
        _isDeleting = true;
      });

      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'VisitLocation$index': FieldValue.delete(),
        'day$index': FieldValue.delete(),
      });

      // ignore: non_constant_identifier_names
      List<dynamic> Data = [];
      DocumentSnapshot<Map<String, dynamic>>? pickupDataDoc =
          await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();
      int number = pickupDataDoc.get('NumberofData');
      int i = index;

      while (i != number) {
        DocumentSnapshot<Map<String, dynamic>>? userDataDoc =
            await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();

        Data = userDataDoc.get('VisitLocation${i + 1}');

        await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
          'VisitLocation$i': Data,
          'day$i': userDataDoc.get('day${i + 1}'),
        });

        i++;
      }

      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'VisitLocation$i': FieldValue.delete(),
        'day$i': FieldValue.delete(),
      });

      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'NumberofData': (i - 1),
      });

      setState(() {
        _isDeleting = false;
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isDeleting = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("経路を削除する際にエラーが発生しました。"),
        ),
      );
    }
  }

  Future<void> _confirmDeleteDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('経路を削除しますか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '削除',
                style: TextStyle(color: Color(0xFFE57373)),
              ),
              onPressed: () {
                _deleteVisitLocationData(context, index);
              },
            ),
          ],
        );
      },
    );
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