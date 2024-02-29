// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KeepMap extends StatefulWidget {
  final int visitLocationIndex;

  const KeepMap(
      {Key? key,
      required this.visitLocationIndex,
      required String lastLocation})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _KeepMapState createState() => _KeepMapState();
}

class _KeepMapState extends State<KeepMap> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<String>> _data;
  late Future<String> _date;
  List<MapData> mapDataList = [];

  // 新たに追加したコントローラーと変数
  GoogleMapController? _googleMapController;

  // 新しいマップの表示位置を設定
  final LatLng _initialCameraPosition =
      const LatLng(35.6895, 139.6917); // 東京タワーの座標

  @override
  void initState() {
    super.initState();
    _data = _fetchDataFromFirestore();
    _date = _fetchDateFromFirestore();
    _fetchMapDataFromFirestore();
  }

  Future<List<String>> _fetchDataFromFirestore() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_old_data')
              .doc(uid)
              .get();

      List<String> dataList = [];
      List<dynamic>? visitLocationData = querySnapshot
          .data()!['VisitLocation${widget.visitLocationIndex + 1}'];
      if (visitLocationData != null && visitLocationData.isNotEmpty) {
        dataList.addAll(visitLocationData.cast<String>().reversed); // 逆順に取得
      }
      return dataList;
    } catch (e) {
      return [];
    }
  }

  Future<void> _fetchMapDataFromFirestore() async {
    // Firestoreからデータを取得
    User? user = _auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>>? userDataDoc =
        await _firestore.collection('user_old_data').doc(user?.uid).get();

    if (userDataDoc.exists) {
      // Firestoreから取得したJSONデータをデコード
      var mapDataListJson =
          userDataDoc.get('mapData${widget.visitLocationIndex + 1}');

      // JSONデータが正しく取得できていることを確認
      if (mapDataListJson != null && mapDataListJson is List<dynamic>) {
        // リストからMapDataオブジェクトを作成
        if (mapDataListJson.isNotEmpty) {
          // 最初の要素を取得
          var mapDataJson = mapDataListJson[0];
          print('mapData${widget.visitLocationIndex + 1}[0]をとれました');

          // MapDataオブジェクトを作成
          if (mapDataJson != null && mapDataJson is Map<String, dynamic>) {
            MapData mapData = MapData.fromJson(mapDataJson);
            print('mapDataをとれました');

            // mapDataListに追加する場合は、以下のように追加
            mapDataList.add(mapData);
            print(mapDataList);
          }
        } else {
          print("Empty mapData list");
        }
      } else {
        print("mapData${widget.visitLocationIndex + 1} is not a List<dynamic>");
      }

      if (_googleMapController != null) {
        LatLngBounds bounds = getBounds(mapDataList.first.routeCoordinates);
        _googleMapController
            ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }

      setState(() {});
    }
  }

  LatLngBounds getBounds(List<LatLng> routeCoordinates) {
    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = -double.infinity;
    double maxLng = -double.infinity;

    for (LatLng coordinate in routeCoordinates) {
      if (coordinate.latitude < minLat) minLat = coordinate.latitude;
      if (coordinate.longitude < minLng) minLng = coordinate.longitude;
      if (coordinate.latitude > maxLat) maxLat = coordinate.latitude;
      if (coordinate.longitude > maxLng) maxLng = coordinate.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<String> _fetchDateFromFirestore() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_old_data')
              .doc(uid)
              .get();

      Timestamp timeStamp =
          querySnapshot.data()!['day${widget.visitLocationIndex + 1}'];

      // タイムスタンプからDateTimeオブジェクトに変換
      DateTime date = timeStamp.toDate();

      // 日付を適切な書式の文字列に変換
      String formattedDate =
          '${date.year}年${date.month}月${date.day}日${date.hour + 9}時${date.minute}分';

      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  Future<void> _deleteVisitLocationData(BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('user_old_data')
          .doc(uid)
          .update({
        'VisitLocation${widget.visitLocationIndex + 1}': FieldValue.delete(),
        'mapData${widget.visitLocationIndex + 1}': FieldValue.delete(),
        'day${widget.visitLocationIndex + 1}': FieldValue.delete(),
      });

      // ignore: non_constant_identifier_names
      List<dynamic> Data = [];
      // ignore: non_constant_identifier_names
      List<dynamic> Data2 = [];
      DocumentSnapshot<Map<String, dynamic>>? pickupDataDoc =
          await FirebaseFirestore.instance
              .collection('user_old_data')
              .doc(uid)
              .get();
      int number = pickupDataDoc.get('NumberofData');
      int i = widget.visitLocationIndex + 1;

      while (i != number) {
        DocumentSnapshot<Map<String, dynamic>>? userDataDoc =
            await FirebaseFirestore.instance
                .collection('user_old_data')
                .doc(uid)
                .get();

        Data = userDataDoc.get('VisitLocation${i + 1}');
        Data2 = userDataDoc.get('mapData${i + 1}');

        await FirebaseFirestore.instance
            .collection('user_old_data')
            .doc(uid)
            .update({
          'VisitLocation$i': Data,
          'mapData$i': Data2,
          'day$i': userDataDoc.get('day${i + 1}'),
        });

        i++;
      }

      await FirebaseFirestore.instance
          .collection('user_old_data')
          .doc(uid)
          .update({
        'NumberofData': (i - 1),
        'VisitLocation$i': FieldValue.delete(),
        'mapData$i': FieldValue.delete(),
        'day$i': FieldValue.delete(),
      });

      setState(() {
        _data = _fetchDataFromFirestore();
      });

      Navigator.pop(context); // プロフィールページに戻る
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("経路を削除する際にエラーが発生しました。"),
        ),
      );
    }
  }

  bool _isMapTapped = false;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.0222, // 左端からの距離
                        MediaQuery.of(context).size.height * 0.0099, // 上端からの距離
                        MediaQuery.of(context).size.width * 0.0222, // 右端からの距離
                        MediaQuery.of(context).size.height * 0.0099, // 下端からの距離
                      ),
                      child: Text(
                        dateSnapshot.data ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.0222, // 左端からの距離
                  MediaQuery.of(context).size.height * 0.0099, // 上端からの距離
                  MediaQuery.of(context).size.width * 0.0222, // 右端からの距離
                  MediaQuery.of(context).size.height * 0.0099, // 下端からの距離
                ),
                child: SizedBox(
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
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        // データがない場合の処理
                        return const Center(
                          child: Text('No data available'),
                        );
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.0099),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.0222, // 左端からの距離
                                  MediaQuery.of(context).size.height * 0.0099, // 上端からの距離
                                  MediaQuery.of(context).size.width * 0.0222, // 右端からの距離
                                  MediaQuery.of(context).size.height * 0.0099, // 下端からの距離
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 94, 107, 158),
                                        width: 5.0),
                                    color: const Color.fromARGB(
                                        255, 215, 233, 250),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: MediaQuery.of(context).size.height * 0.00249,
                                    horizontal: MediaQuery.of(context).size.width * 0.00555,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.zero, 
                                          title: const Text(
                                            '出発地点',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context).size.height * 0.00249,
                                                horizontal: MediaQuery.of(context).size.width * 0.00185,
                                              ),
                                              child: const Icon(Icons.arrow_downward),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.0099),
                                        for (int i = snapshot.data!.length - 1;
                                            i >= 0;
                                            i--)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context).size.height * 0.00249,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (i < snapshot.data!.length)
                                                  Text(
                                                    snapshot.data![i],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.0099),
                                                const Icon(
                                                    Icons.arrow_downward),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.0099),
                                        const ListTile(
                                          contentPadding: EdgeInsets.zero, 
                                          title: Text(
                                            'ゴール',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.0099),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.0222, // 左端からの距離
                  MediaQuery.of(context).size.height * 0.0099, // 上端からの距離
                  MediaQuery.of(context).size.width * 0.0222, // 右端からの距離
                  MediaQuery.of(context).size.height * 0.0099, // 下端からの距離
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.5, // GoogleMapの高さを指定
                  child: GestureDetector(
                    onTapDown: (_) {
                      // マップがタップされたときにフラグを有効にする
                      setState(() {
                        _isMapTapped = true;
                      });
                    },
                    onTapUp: (_) {
                      // マップがタップ解除されたときにフラグを無効にする
                      setState(() {
                        _isMapTapped = false;
                      });
                    },
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: mapDataList.isNotEmpty
                          ? Set.from(mapDataList.first.markers)
                          : <Marker>{},
                      polylines: mapDataList.isNotEmpty
                          ? Set.from(mapDataList.first.polylines)
                          : <Polyline>{},
                      onMapCreated: (controller) {
                        _googleMapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: _initialCameraPosition,
                        zoom: 12.0,
                      ),
                      gestureRecognizers: _isMapTapped
                          ? <Factory<OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            }
                          : <Factory<OneSequenceGestureRecognizer>>{},
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.0222),
                child: SizedBox(
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // テキストの色
                    ),
                    child: const Text('経路を削除'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RouteDeletion extends StatelessWidget {
  final Function onDelete;

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
          onPressed: () {
            onDelete(); // 経路を削除
            Navigator.pop(context);
          },
          child: const Text('削除'),
        ),
      ],
    );
  }
}

class MapData {
  final List<Marker> markers;
  final List<Polyline> polylines;
  final List<LatLng> routeCoordinates;

  MapData({
    required this.markers,
    required this.polylines,
    required this.routeCoordinates,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    // markers データから Marker オブジェクトを作成
    List<Marker> markersList =
        (json['markers'] as List<dynamic>).map((markerData) {
      final info = markerData['info'];
      final position = markerData['position'];

      return Marker(
        markerId: MarkerId(markerData['markerId'] ?? ''),
        infoWindow: InfoWindow(
          title: info['title'],
          snippet: info['snippet'],
        ),
        position: LatLng(
          position['latitude'],
          position['longitude'],
        ),
      );
    }).toList();

    // polylines データから Polyline オブジェクトを作成
    List<Polyline> polylinesList =
        (json['polylines'] as List<dynamic>).map((polylineData) {
      final List<Map<String, dynamic>> polylinePoints =
          (polylineData['points'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

      return Polyline(
        polylineId: PolylineId(polylineData['polylineId'] ?? ''),
        color: Color(polylineData['color']),
        points: polylinePoints
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList(),
        width: polylineData['width'],
      );
    }).toList();

    // routeCoordinates データから LatLng オブジェクトを作成
    List<LatLng> routeCoordinatesList =
        (json['routeCoordinates'] as List<dynamic>).map((coord) {
      return LatLng(coord['latitude'], coord['longitude']);
    }).toList();

    return MapData(
      markers: markersList,
      polylines: polylinesList,
      routeCoordinates: routeCoordinatesList,
    );
  }
}
