import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_final/login.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position lokasi = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  String Alamat = 'Mencari lokasi......';

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  getLokasi() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var hasil = await Geolocator.getCurrentPosition();
    var placemarks =
        await placemarkFromCoordinates(hasil.latitude, hasil.longitude);
    var hasilplacemark = placemarks[0];

    setState(() {
      lokasi = hasil;
      Alamat =
          "${hasilplacemark.street}, ${hasilplacemark.postalCode},\n${hasilplacemark.locality}, ${hasilplacemark.administrativeArea}";
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print(auth.currentUser!.email);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocator"),
        centerTitle: true,
        leading: Text(''),
        actions: [
          IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Apakah anda yakin ingin logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => Login())),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Koordinat Point',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${lokasi.latitude}, ${lokasi.longitude}',
          textAlign: TextAlign.center,
        ),
        Container(),
        SizedBox(
          height: 8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Alamat',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${Alamat}',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var intent = AndroidIntent(
                    action: 'action_view', data: 'https://maps.google.com');

                await intent.launch();
              },
              child: Text(
                'Buka Maps',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: getLokasi,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
