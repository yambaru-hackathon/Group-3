import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// ignore: library_prefixes
import 'package:geocoding/geocoding.dart' as geoCoding;

// ignore: unused_element
Future<String?> _determinePosition() async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if(!serviceEnabled){
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      return Future.error('Location permissions are denied.');
    }
  }

  if(permission == LocationPermission.deniedForever){
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.'
    );
  }

  final position =  await Geolocator.getCurrentPosition();
  final placeMarks = await geoCoding.placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: "JP");
  final placeMark = [placeMarks[0].country, placeMarks[0].administrativeArea, placeMarks[0].locality];
  return placeMark[0];
  }

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 2.0,
                scaleEnabled: true,
                panEnabled: true,
                constrained: false,
                child: Image.asset(
                  'lib/images/map.png',
                ),
              )
            ),
          ],
        )
      )
    );
  }
}
