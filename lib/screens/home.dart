import 'dart:async';
import 'dart:io';

import 'package:appentus/code/database.dart';
import 'package:appentus/code/models.dart';
import 'package:appentus/screens/second.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = dummy;
  LatLng? location;
  bool isPermanentlyDenied = false;
  Completer<GoogleMapController> _controller = Completer();

  logout(UserInfo userInfo) async {
    userInfo.updateToken('');
    user = dummy;
    var box = await Hive.openBox('myBox');
    await box.delete('token');
  }

  getUser(UserInfo userInfo) async {
    user = await UsersDatabase.instance.getUser(int.parse(userInfo.token));
    setState(() {});
  }

  handlePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return openDialog('Error', 'Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return openDialog('Permissions required', 'Please allow location permissions to be able to use the map feature', request: true);
      }
    }
    setState(() {
      isPermanentlyDenied = false;
    });

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isPermanentlyDenied = true;
      });
      return openDialog('Error',
          'Location permissions are permanently denied, we cannot request permissions. Please open app settings and enable permissions manually to use the map feature.');
    }

    Position position = await Geolocator.getCurrentPosition();
    location = LatLng(position.latitude, position.longitude);
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newLatLng(location!));
  }

  Future openDialog(String title, String text, {bool request = false}) async {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(request ? 'Cancel' : 'Okay')),
        request
            ? TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handlePermissions();
                },
                child: Text('Grant permission'))
            : SizedBox.shrink()
      ],
    );
    await showDialog(context: context, builder: (context) => dialog);
  }

  @override
  void initState() {
    super.initState();
    handlePermissions();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final userInfo = Provider.of<UserInfo>(context);
    getUser(userInfo);
    titleWidget() => Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipOval(
                child: user.image.isNotEmpty
                    ? Image.file(
                        File(user.image),
                        fit: BoxFit.cover,
                      )
                    : SizedBox.shrink(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(user.name),
              ),
            )
          ],
        );

    Widget buildMap() {
      CameraPosition initialCameraPosition = CameraPosition(
        target: location ?? LatLng(28.6139, 77.2090), // New Delhi lat lng for default value
        zoom: 14.4746,
      );
      var _markers = Set<Marker>()..add(Marker(markerId: MarkerId('location'), position: location ?? LatLng(28.6139, 77.2090)));
      loadingWidget() => Container(
            color: Colors.white.withOpacity(0.9),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !isPermanentlyDenied
                      ? Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox.shrink(),
                  Text(
                    !isPermanentlyDenied
                        ? 'Fetching location. Please wait'
                        : 'Location permissions not granted. Please open app settings, enable locations and restart app',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
      return Container(
        width: width,
        padding: EdgeInsets.all(8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  // liteModeEnabled: true,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  gestureRecognizers: Set()..add(Factory(() => EagerGestureRecognizer()))),
              location == null ? loadingWidget() : SizedBox.shrink()
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: titleWidget(),
        actions: [
          TextButton(
              onPressed: () => logout(userInfo),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            buildMap(),
            OutlinedButton(
                onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => SecondPage())),
                child: Text('Second Screen'))
          ],
        ),
      ),
    );
  }
}
