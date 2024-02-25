import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KeepMap extends StatefulWidget {
  final int visitLocationIndex;

  const KeepMap({Key? key, required this.visitLocationIndex}) : super(key: key);

  @override
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

      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'VisitLocation${widget.visitLocationIndex + 1}': FieldValue.delete(),
      });

      setState(() {
        _data = _fetchDataFromFirestore();
      });
    } catch (e) {
      print('Error deleting visit location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteVisitLocationData,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xffaabbff),
              ),
              child: const Text(
                'VisitLocation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            FutureBuilder<List<String>>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length + 2, // 現在地とゴールを含めるために+2
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: Text(
                            '出発地点',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: const 
                              Icon(Icons.arrow_downward),
                            ),
                          ),
                        );
                      } else if (index == snapshot.data!.length + 1) {
                        return ListTile(
                          title: Text(
                            'ゴール',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(
                            snapshot.data![index - 1],
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: const 
                              Icon(Icons.arrow_downward),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}