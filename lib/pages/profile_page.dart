// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:group3/keep/keep_map.dart';
import 'dart:convert';

import 'package:group3/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int numberOfData = 1;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    //await _prefs.clear(); //shared preferences をすべてクリア
    // ローカルに保存してあるcounterの値をnumberOfDataに代入
    setState(() {
      numberOfData = _prefs.getInt('counter') ?? 0;
      print(numberOfData);
    });
  }

  void _reloadPage() {
    setState(() {
      _initSharedPreferences();
    });
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
                  var emailParts = email.split('@');
                  var displayEmail =
                      emailParts.isNotEmpty ? emailParts[0] : 'No email';
                  return Column(
                    children: [
                      const Icon(Icons.account_circle,
                          size: 80, color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayEmail,
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
                      child: StreamBuilder<List<List<String>>>(
                        // 2. Firestoreからのデータ取得から変更
                        stream: _fetchDataFromSharedPreferencesStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<List<String>> visitLocationDataList =
                                snapshot.data ?? <List<String>>[];

                            numberOfData = visitLocationDataList.length;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3.0,
                                ),
                                itemCount: numberOfData,
                                itemBuilder: (context, index) {
                                  final visitLocationData =
                                      visitLocationDataList[index];

                                  final visitLocationText =
                                      visitLocationData.join(", ");
                                  final lastLocation =
                                      visitLocationText.split(',').last.trim();
                                  final timeStamp = DateTime
                                      .now(); // Change to your desired DateTime
                                  final formattedDate =
                                      '${timeStamp.year}/${timeStamp.month}/${timeStamp.day}';

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KeepMap(
                                              visitLocationIndex: index,
                                              lastLocation: ''),
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
                                            color: Color(0x95949480),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                            bottom: 0,
                                            right: 10,
                                            child: FutureBuilder<String>(
                                              future:
                                                  fetchImageUrlFromFirestore(
                                                      lastLocation),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError ||
                                                    snapshot.data!.isEmpty) {
                                                  return Image.asset(
                                                      'lib/images/book3.png',
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover);
                                                } else {
                                                  return Image.network(
                                                    snapshot.data!,
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
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 50,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('すべての経路を削除しますか？'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('キャンセル'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      '削除',
                                      style:
                                          TextStyle(color: Color(0xFFE57373)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // ダイアログを閉じる
                                      _deleteVisitLocationData(
                                        context,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _reloadPage();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<List<String>>> _fetchDataFromSharedPreferencesStream() async* {
    try {
      int number = _prefs.getInt('counter') ?? 1;
      List<List<String>> visitLocationDataList = [];

      for (int i = 0; i < number; i++) {
        String visitLocationKey = 'VisitLocation$i';

        // ここで直接 String を取得するのではなく、List<String>? を取得するように変更
        List<String>? visitLocationData =
            _prefs.getStringList(visitLocationKey);

        if (visitLocationData != null) {
          visitLocationDataList.add(visitLocationData);
        }
      }

      yield visitLocationDataList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _deleteVisitLocationData(BuildContext context) async {
    try {
      setState(() {});

      // SharedPreferencesから経路データを削除
      await _prefs.remove('counter');
      for (int i = 0; i < numberOfData; i++) {
        await _prefs.remove('VisitLocation$i');
        await _prefs.remove('day$i');
        await _prefs.remove('mapData$i');
      }

      setState(() {
        numberOfData = 0; // カウンターをリセット
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("すべての経路が削除されました"),
        ),
      );
    } catch (e) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("経路を削除する際にエラーが発生しました。"),
        ),
      );
    }
  }

  Future<String> fetchImageUrlFromFirestore(String lastLocation) async {
    try {
      String apiKey = 'AIzaSyCwTPS1JbpKwPqSV2mQWzLXX-Pq1sb_9P0';
      String imageUrl = await fetchImageUrlFromPlacesAPI(apiKey, lastLocation);
      if (imageUrl.isNotEmpty) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('picture_data')
            .doc(uid)
            .set({
          'imgURL': imageUrl,
        });
      }
      return imageUrl;
    } catch (e) {
      print('Error fetching image URL from Firestore: $e');
      return ''; // エラー時は空の文字列を返します
    }
  }

  Future<String> fetchImageUrlFromPlacesAPI(
      String apiKey, String lastLocation) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    String query = Uri.encodeComponent(lastLocation);
    String url = '$baseUrl?key=$apiKey&input=$query&inputtype=textquery';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          var placeId = data['candidates'][0]['place_id'];
          return await fetchPhotoReference(apiKey, placeId);
        } else {
          print('No candidates found');
          return '';
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error sending request: $e');
      return '';
    }
  }

  Future<String> fetchPhotoReference(String apiKey, String placeId) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    String url = '$baseUrl?key=$apiKey&place_id=$placeId&fields=photos';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['result'] != null &&
            data['result']['photos'] != null &&
            data['result']['photos'].isNotEmpty) {
          var photoReference = data['result']['photos'][0]['photo_reference'];
          return fetchPhotoUrl(apiKey, photoReference);
        } else {
          print('No photos found');
          return '';
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error sending request: $e');
      return '';
    }
  }

  Future<String> fetchPhotoUrl(String apiKey, String photoReference) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/photo';
    String url =
        '$baseUrl?key=$apiKey&photoreference=$photoReference&maxheight=200';

    return url;
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
