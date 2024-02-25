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

      await FirebaseFirestore.instance.collection('user_old_data').doc(uid).update({
        'VisitLocation${widget.visitLocationIndex + 1}': FieldValue.delete(),
      });

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Navinator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteVisitLocationData,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffaabbff),
              ),
              child: Text(
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
                        return const ListTile(
                          title: Text(
                            '出発地点',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.arrow_downward),
                            ),
                          ),
                        );
                      } else if (index == snapshot.data!.length + 1) {
                        return const ListTile(
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
                          subtitle: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.arrow_downward),
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