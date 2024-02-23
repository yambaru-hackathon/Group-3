import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KeepMap extends StatefulWidget {
  final int visitLocationIndex;

  const KeepMap({Key? key, required this.visitLocationIndex}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _KeepMapState createState() => _KeepMapState();
}

class _KeepMapState extends State<KeepMap> {
  late Future<List<String>> _data;

  @override
  void initState() {
    super.initState();
    _data = _fetchDataFromFirestore();
  }

  Future<List<String>> _fetchDataFromFirestore() async {
    try {
      // ログインユーザーのUIDを取得
      String uid = FirebaseAuth.instance.currentUser!.uid;
      
      // Firestoreからデータを取得する
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();

      // 取得したデータをリストに変換して返す
      List<String> dataList = [];
      List<dynamic>? visitLocationData = querySnapshot.data()!['VisitLocation${widget.visitLocationIndex + 1}'];
      if (visitLocationData != null && visitLocationData.isNotEmpty) {
        dataList.addAll(visitLocationData.cast<String>());
      }
      return dataList;
    } catch (e) {
      return []; // エラーが発生した場合は空のリストを返す
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行ったとこ表示'),
      ),
      body: FutureBuilder<List<String>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // データをリストビューに表示
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data![index],
                    textAlign: TextAlign.center,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}