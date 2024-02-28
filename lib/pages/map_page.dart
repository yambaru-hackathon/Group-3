// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// ignore: library_prefixes
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class ScaleFixer extends StatelessWidget {
  const ScaleFixer({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransformationController>();
    // Transforn.scaleでchildをscale倍に拡大する
    return Transform.scale(
      scale: 1 / controller.value.getMaxScaleOnAxis(),
      child: child,
    );
  }
}


class _MapPageState extends State<MapPage> {
  
  final upL = [27.200, 127.400];
  final upR = [27.200, 128.600];
  final downL = [26.000, 127.400];
  Map<String, List> prefpin = { //pref: [left, top]
    'Iheya': [582, 87, '伊平屋村'],
    'Izena' : [560, 210, '伊是名村'],
    'Kunigami': [790, 420, '国頭村'],
    'Higashi': [775, 540, '東村'],
    'Ōgimi': [740, 465, '大宜味村'],
    'Nago': [595, 585, '名護市'],
    'Nakijin': [590, 485, '今帰仁村'],
    'Motobu': [515, 515, '本部町'],
    'Ie': [425, 455, '伊江村'],
    'Ginoza': [595, 710, '宜野座村'],
    'Onna': [470, 690, '恩納村'],
    'Kin': [540, 740, '金武町'],
    'Uruma': [480, 825, 'うるま市'],
    'Okinawa': [425, 875, '沖縄市'],
    'Kadena': [375, 845, '嘉手納町'],
    'Yomitan': [365, 805, '読谷村'],
    'Chatan': [385, 890, '北谷町'],
    'Kitanakagusuku': [410, 910, '北中城村'],
    'Nakagusuku': [415, 945, '中城村'],
    'Ginowan': [395, 935, '宜野湾市'],
    'Nishihara': [380, 995, '西原町'],
    'Urasoe': [340, 975, '浦添市'],
    'Naha': [300, 1015,'那覇市'],
    'Yonabaru': [375, 1030, '与那原町'],
    'Haebaru': [350, 1035, '南風原町'],
    'Tomigusuku': [290, 1070, '豊見城市'],
    'Nanjō': [395, 1070, '南城市'],
    'Yaese': [335, 1075, '八重瀬町'],
    'Itoman': [285, 1105, '糸満市']
    };

  static const mapWidth = 1200;
  List<double> position = [0.0, 0.0];
  String Locality = 'No_data';
  DocumentReference docRef = FirebaseFirestore.instance.collection('map').doc('congestion');
  int fieldValue = -999;
  // ignore: prefer_typing_uninitialized_variables
  var field;
  final List<String> Pin = [
    'lib/images/pin_green.png',
    'lib/images/pin_yellow.png',
    'lib/images/pin_red.png'
    ];
    final TransformationController _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    _initLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      updatePosition();
    });
  }

  Future<void> _initLocation() async {
    await _determinePosition();
    await increment_data(1);
    await getDataFromFirestore();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position pos = await Geolocator.getCurrentPosition();
    List<Placemark> placeMarks = await geoCoding
        .placemarkFromCoordinates(pos.latitude, pos.longitude, localeIdentifier: "JP");

    setState(() {
      position = [pos.latitude, pos.longitude];
      Locality = placeMarks[0].locality.toString();
    });
    
    return;
  }
  
  Future<void> getDataFromFirestore() async {
    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      fieldValue = docSnapshot.get(Locality);
    }
    setState(() {
      fieldValue = docSnapshot.get(Locality);
      field = docSnapshot.data();
    });
  }

  Future<void> increment_data(int num) async{
    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      docRef.update({Locality:FieldValue.increment(num)});
    }
  }

  List<double> _positionFormat() {
    double DLR = Geolocator.distanceBetween(upL[0], upL[1], upR[0], upR[1]);
    double DL = Geolocator.distanceBetween(upL[0], upL[1], downL[0], downL[1]);
    double DupL = Geolocator.distanceBetween(upL[0], upL[1], position[0], position[1]);
    double DupR = Geolocator.distanceBetween(upR[0], upR[1], position[0], position[1]);
    double DdownL =
        Geolocator.distanceBetween(downL[0], downL[1], position[0], position[1]);

    double x = (DLR * DLR + DupL * DupL - DupR * DupR) / (2 * DLR * DLR);
    double y = (DL * DL + DupL * DupL - DdownL * DdownL) / (2 * DL * DL);

    return ([mapWidth * x, mapWidth * y]);
  }

  Future<void> updatePosition() async{
    Position pos = await Geolocator.getCurrentPosition();
    List<Placemark> placeMarks = await geoCoding
        .placemarkFromCoordinates(pos.latitude, pos.longitude, localeIdentifier: "JP");
    if(Locality != placeMarks[0].locality.toString()){
        await increment_data(-1);
        await _determinePosition();
        await increment_data(1);
        await getDataFromFirestore();
        print('f');
    }
    else{
      print('else');
    }
  }

  String pinstatus(String pref){
    if(field == null){
      return Pin[0];
    }
    else{
      if(field[pref] == 1){
        return Pin[1];
      }
      else if(field[pref] >= 2){
        return Pin[2];
      }
      else{
        return Pin[0];
      }
    }
  }

  Widget prefname(String pref){
    if(_controller.value.getMaxScaleOnAxis() >= 2.5){
      return  Text(prefpin[pref]![2], style: const TextStyle(fontSize: 10), textAlign: TextAlign.center,);
      
    }
    return const Text('', style: TextStyle(fontSize: 10), textAlign: TextAlign.center);
  }

  Widget printpin(String pref){
    List? pos = prefpin[pref];
    return Positioned(
      left: pos![0] * 
            MediaQuery.of(context).size.width /
            mapWidth - 20,
      top: pos[1] * 
            MediaQuery.of(context).size.width /
            mapWidth - 40 + (1 - 1 / _controller.value.getMaxScaleOnAxis()) * 40 / 2,
      child: Transform.scale(
        scale: 1 / _controller.value.getMaxScaleOnAxis(),
        child: Stack(
        children: [
          Image.asset(
          pinstatus(pref),
          height: 40,
          width: 40
        ),
        prefname(pref)
        ])
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbbccff),
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
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 800,
            width: 600,
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 1.0,
              maxScale: 5.0,
              scaleEnabled: true,
              panEnabled: true,
              constrained: true,
              onInteractionUpdate: (details) {
                setState(() {});
              },
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    
                    Image.asset(
                      'lib/images/map_okinawa_white.png',
                    ),
                    Text('$fieldValue,$Locality'),
                    
                    
                    printpin('Iheya'),
                    printpin('Izena'),
                    printpin('Kunigami'),
                    printpin('Ōgimi'),
                    printpin('Higashi'),
                    printpin('Nago'),
                    printpin('Nakijin'),
                    printpin('Motobu'),
                    printpin('Ie'),
                    printpin('Ginoza'),
                    printpin('Onna'),
                    printpin('Uruma'),
                    printpin('Yomitan'),
                    printpin('Kin'),
                    printpin('Kadena'),
                    printpin('Okinawa'),
                    printpin('Chatan'),
                    printpin('Kitanakagusuku'),
                    printpin('Ginowan'),
                    printpin('Nakagusuku'),
                    printpin('Urasoe'),
                    printpin('Nishihara'),
                    printpin('Naha'),
                    printpin('Yonabaru'),
                    printpin('Haebaru'),
                    printpin('Tomigusuku'),
                    printpin('Nanjō'),
                    printpin('Yaese'),
                    printpin('Itoman'),
                    
                    Positioned(
                      left: _positionFormat()[0] *
                          MediaQuery.of(context).size.width /
                          mapWidth - 15,
                      top: _positionFormat()[1] *
                          MediaQuery.of(context).size.width /
                          mapWidth - 15,
                      child: Transform.scale(
                        scale: 1 / _controller.value.getMaxScaleOnAxis(),
                        child: Image.asset(
                          'lib/images/pin_current.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}