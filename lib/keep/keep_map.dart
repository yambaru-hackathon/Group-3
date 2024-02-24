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
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('user_old_data').doc(uid).get();

      List<String> dataList = [];
      List<dynamic>? visitLocationData =
          querySnapshot.data()!['VisitLocation${widget.visitLocationIndex + 1}'];
      if (visitLocationData != null && visitLocationData.isNotEmpty) {
        dataList.addAll(visitLocationData.cast<String>());
      }
      return dataList.reversed.toList(); 
    } catch (e) {
      return [];
    }
  }

  void _deleteVisitLocationData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // VisitLocationが格納されているドキュメントを削除
      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'VisitLocation${widget.visitLocationIndex + 1}': FieldValue.delete(),
      });

      // データ再取得
      setState(() {
        _data = _fetchDataFromFirestore();
      });
    // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行ったとこ表示'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteVisitLocationData,
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
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