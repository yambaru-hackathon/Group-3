import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KeepMap extends StatefulWidget {
  final int visitLocationIndex;
  final String lastLocation; // 最後の場所を受け取る

  const KeepMap({Key? key, required this.visitLocationIndex, required this.lastLocation}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _KeepMapState createState() => _KeepMapState();
}

class _KeepMapState extends State<KeepMap> {
  late Future<List<String>> _data;
  late Future<String> _date;

  @override
  void initState() {
    super.initState();
    _data = _fetchDataFromFirestore();
    _date = _fetchDateFromFirestore();
  }

  Future<List<String>> _fetchDataFromFirestore() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();

      List<String> dataList = [];
      List<dynamic>? visitLocationData =
          querySnapshot.data()!['VisitLocation${widget.visitLocationIndex + 1}'];
      if (visitLocationData != null && visitLocationData.isNotEmpty) {
        dataList.addAll(visitLocationData.cast<String>().reversed); // 逆順に取得
      }
      return dataList;
    } catch (e) {
      return [];
    }
  }

  Future<String> _fetchDateFromFirestore() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();

      Timestamp timeStamp = querySnapshot.data()!['day${widget.visitLocationIndex + 1}'];

      // タイムスタンプからDateTimeオブジェクトに変換
      DateTime date = timeStamp.toDate();

      // 日付を適切な書式の文字列に変換
      String formattedDate = '${date.year}年${date.month}月${date.day}日${date.hour}時${date.minute}分';

      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  Future<void> _deleteVisitLocationData(BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'VisitLocation${widget.visitLocationIndex + 1}': FieldValue.delete(),
        'day${widget.visitLocationIndex + 1}': FieldValue.delete(),
      });

      // ignore: non_constant_identifier_names
      List<dynamic> Data = [];
      DocumentSnapshot<Map<String, dynamic>>? pickupDataDoc =
          await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();
      int number = pickupDataDoc.get('NumberofData');
      int i = widget.visitLocationIndex + 1;

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
        _data = _fetchDataFromFirestore();
      });
    } catch (e) {
      // エラーハンドリング
      // エラーが発生してもダイアログを閉じる
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // 必要に応じて、ユーザーにエラーメッセージを表示する
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("経路を削除する際にエラーが発生しました。"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Navinator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
            future: _date,
            builder: (context, dateSnapshot) {
              if (dateSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dateSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${dateSnapshot.error}'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dateSnapshot.data ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView(
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 94, 107, 158), width: 5.0),
                            color: const Color.fromARGB(255, 215, 233, 250),
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              const ListTile(
                                title: Text(
                                  '出発地点',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.arrow_downward),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              for (int i = snapshot.data!.length - 1; i >= 0; i--) // 逆順に表示
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data![i],
                                        textAlign: TextAlign.center,
                                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8), // テキストとアイコンの間の間隔
                                      const Icon(Icons.arrow_downward),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 8),
                              ListTile(
                                title: Text(
                                  'ゴール',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                }
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return RouteDeletion(
                      onDelete: () => _deleteVisitLocationData(context),
                    );
                  },
                );
              },
              child: const Text('経路を削除'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // テキストの色
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RouteDeletion extends StatelessWidget {
  final onDelete;

  const RouteDeletion({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('経路を削除しますか？'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: onDelete,
          child: const Text('削除'),
        ),
      ],
    );
  }
}