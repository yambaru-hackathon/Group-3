// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// ignore: library_prefixes
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<double> pos = [0, 0];
  List<String> marks = ['', '', ''];
  final upL = [27.200, 127.400];
  final upR = [27.200, 128.600];
  final downL = [26.000, 127.400];
  static const mapWidth = 1200;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    await _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

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

    Position position = await Geolocator.getCurrentPosition();
    pos = [position.latitude, position.longitude];
    List<Placemark> placeMarks = await geoCoding
        .placemarkFromCoordinates(pos[0], pos[1], localeIdentifier: "JP");
    marks = [
      placeMarks[0].country.toString(),
      placeMarks[0].administrativeArea.toString(),
      placeMarks[0].locality.toString()
    ];

    setState(() {
      pos = [position.latitude, position.longitude];
      marks = [
        placeMarks[0].country.toString(),
        placeMarks[0].administrativeArea.toString(),
        placeMarks[0].locality.toString()
      ];
    });
    
    return;
  }

  List<double> _positionFormat() {
    double DLR = Geolocator.distanceBetween(upL[0], upL[1], upR[0], upR[1]);
    double DL = Geolocator.distanceBetween(upL[0], upL[1], downL[0], downL[1]);
    double DupL = Geolocator.distanceBetween(upL[0], upL[1], pos[0], pos[1]);
    double DupR = Geolocator.distanceBetween(upR[0], upR[1], pos[0], pos[1]);
    double DdownL =
        Geolocator.distanceBetween(downL[0], downL[1], pos[0], pos[1]);

    double x = (DLR * DLR + DupL * DupL - DupR * DupR) / (2 * DLR * DLR);
    double y = (DL * DL + DupL * DupL - DdownL * DdownL) / (2 * DL * DL);

    return ([mapWidth * x, mapWidth * y]);
  }

  @override
  Widget build(BuildContext context) {
    _determinePosition();
    return Scaffold(
      backgroundColor: const Color(0xffbbccff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Row(
            children: [
              Image.asset(
                'lib/images/napi.png',
                height: 50,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_think.png',
                height: 50,
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
                height: 50,
              ),
              const Spacer(),
              Image.asset(
                'lib/images/napi_kirakira.png',
                height: 50,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 800,
            width: 600,
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 60.0,
              scaleEnabled: true,
              panEnabled: true,
              constrained: true,
              child: Center(
                child: Stack(
                  children: [
                    Image.asset(
                      'lib/images/map_okinawa_white.png',
                    ),
                    Text(
                        //'${placeMarks[0].country}.${placeMarks[0].administrativeArea}.${placeMarks[0].locality}'
                        '$pos.$marks'),
                    Positioned(
                      left: _positionFormat()[0] *
                          MediaQuery.of(context).size.width /
                          mapWidth,
                      top: _positionFormat()[1] *
                          MediaQuery.of(context).size.width /
                          mapWidth,
                      child: Image.asset(
                        'lib/images/pin_current.png',
                        height: 25,
                        width: 25,
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
