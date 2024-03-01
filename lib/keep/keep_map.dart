// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late Future<List<String>> _data;
  late Future<String> _date;
  List<MapData> mapDataList = [];

  late SharedPreferences _prefs;

  // 新たに追加したコントローラーと変数
  GoogleMapController? _googleMapController;

  // 新しいマップの表示位置を設定
  final LatLng _initialCameraPosition =
      const LatLng(35.6895, 139.6917); // 東京タワーの座標

  @override
  initState() {
    super.initState();
    _initSharedPreferences();
    _data = _fetchDataFromSharedPreferences();
    _date = _fetchDateFromSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // await _prefs.clear();
    await _fetchMapDataFromSharedPreferences();
  }

  Future<List<String>> _fetchDataFromSharedPreferences() async {
    try {
      // SharedPreferencesからデータを取得
      List<String>? dataList =
          _prefs.getStringList('VisitLocation${widget.visitLocationIndex}');

      // 取得したデータがnullでないことを確認
      if (dataList != null) {
        print("dataを読み取りました");
        return dataList.reversed.toList(); // リストを逆順にして返す
      } else {
        print("VisitLocation${widget.visitLocationIndex} is empty");
        return [];
      }
    } catch (e) {
      print("VisitLocation${widget.visitLocationIndex} is error");
      return [];
    }
  }

  Future<void> _fetchMapDataFromSharedPreferences() async {
    try {
      // SharedPreferencesからデータを取得
      List<String>? mapDataJsonList =
          _prefs.getStringList('mapData${widget.visitLocationIndex}');

      if (mapDataJsonList != null) {
        // mapDataList を新しく作成して追加
        List<MapData> updatedMapDataList = mapDataJsonList.map((mapDataJson) {
          return MapData.fromJson(json.decode(mapDataJson));
        }).toList();

        if (_googleMapController != null) {
          LatLngBounds bounds =
              getBounds(updatedMapDataList.first.routeCoordinates);
          _googleMapController
              ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }

        setState(() {
          mapDataList = updatedMapDataList;
        });
      }
    } catch (e) {
      // エラーハンドリングが必要な場合は適切な処理を追加
      print("mapData${widget.visitLocationIndex + 1} is error");
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

  Future<String> _fetchDateFromSharedPreferences() async {
    try {
      // SharedPreferencesからデータを取得
      Timestamp timeStamp = Timestamp.fromMillisecondsSinceEpoch(
          _prefs.getInt('day${widget.visitLocationIndex + 1}') ?? 0);

      // タイムスタンプからDateTimeオブジェクトに変換
      DateTime date = timeStamp.toDate();

      // 日付を適切な書式の文字列に変換
      String formattedDate =
          '${date.year}年${date.month}月${date.day}日${date.hour + 9}時${date.minute}分';
      print("dateを読み取りました");
      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  Future<void> _deleteVisitLocationData(BuildContext context) async {
    try {
      // Firestoreの代わりにSharedPreferencesを使用
      await _prefs.remove('VisitLocation${widget.visitLocationIndex + 1}');
      await _prefs.remove('mapData${widget.visitLocationIndex + 1}');
      await _prefs.remove('day${widget.visitLocationIndex + 1}');

      // 番号やデータを削除する処理もSharedPreferencesを使用するように変更

      int number = _prefs.getInt('counter') ?? 0;
      int i = widget.visitLocationIndex + 1;

      while (i < number) {
        List<String>? data =
            _prefs.getStringList('VisitLocation${i + 1}')?.cast<String>() ?? [];
        List<String>? data2 =
            _prefs.getStringList('mapData${i + 1}')?.cast<String>() ?? [];
        String? day = _prefs.getString('day${i + 1}') ?? '';

        _prefs.setStringList('VisitLocation$i', data);
        _prefs.setStringList('mapData$i', data2);
        _prefs.setString('day$i', day);

        i++;
      }

      _prefs.setInt('counter', i);
      _prefs.remove('VisitLocation$i');
      _prefs.remove('mapData$i');
      _prefs.remove('day$i');

      setState(() {
        _data = _fetchDataFromSharedPreferences();
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
                                        color: const Color.fromARGB(255, 94, 107, 158),width: 2.0),
                                    borderRadius: BorderRadius.circular(8),
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
