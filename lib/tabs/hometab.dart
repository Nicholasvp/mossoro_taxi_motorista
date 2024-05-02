import 'dart:async';

import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/datamodels/driver.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/helpers/pushnotificationservice.dart';
import 'package:mossorotaximotorista/widgets/AvailabilityButton.dart';
import 'package:mossorotaximotorista/widgets/ConfirmSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();

  DatabaseReference? tripRequestRef;

  var geoLocator = Geolocator();
  var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  String availabilityTitle = 'OFFLINE';
  Color availabilityColor = Colors.red;

  bool isAvailable = false;

  Future<Position?> getCurrentPosition() async {
    isAvailable = await Geolocator.isLocationServiceEnabled();
    if (!isAvailable) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission geolocationStatus = await Geolocator.checkPermission();
    if (geolocationStatus == LocationPermission.always ||
        geolocationStatus == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      setState(() {
        currentPosition = position;
      });

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController!.animateCamera(CameraUpdate.newLatLng(pos));
      return position;
    } else {
      geolocationStatus = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      setState(() {
        currentPosition = position;
      });
    }
    return null;
  }

  void getCurrentDriverInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}');
    driverRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        currentDriverInfo = Driver.fromSnapshot(event.snapshot);
        print(currentDriverInfo!.fullName);
      }
    });

    DatabaseReference driversAvailableRef = FirebaseDatabase.instance
        .ref()
        .child('driversAvailable/${currentFirebaseUser!.uid}');
    driversAvailableRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        getLocationUpdates();
        goOnline();
        setState(() {
          availabilityColor = BrandColors.colorGreen;
          availabilityTitle = 'ONLINE';
          isAvailable = true;
        });
      }
    });

    // PushNotificationService pushNotificationService = PushNotificationService();

    // pushNotificationService.initialize(context);
    // pushNotificationService.getToken();
  }

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            print('Map created');
            mapController = controller;

            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorCampanha,
        ),
        (currentPosition != null)
            ? Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AvailabilityButton(
                      title: availabilityTitle,
                      color: availabilityColor,
                      onPressed: () {
                        showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          builder: (BuildContext context) => ConfirmSheet(
                            title: (!isAvailable) ? 'ONLINE' : 'OFFLINE',
                            subtitle: (!isAvailable)
                                ? 'Você está prestes a ficar disponível para receber solicitações de viagem'
                                : 'Você deixará de receber novas solicitações de viagem',
                            onPressed: () {
                              if (!isAvailable) {
                                goOnline();
                                getLocationUpdates();
                                Navigator.pop(context);

                                setState(() {
                                  availabilityColor = BrandColors.colorGreen;
                                  availabilityTitle = 'ONLINE';
                                  isAvailable = true;
                                });
                              } else {
                                goOffline();
                                Navigator.pop(context);
                                setState(() {
                                  availabilityColor = Colors.red;
                                  availabilityTitle = 'OFFLINE';
                                  isAvailable = false;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AvailabilityButton(
                      title: 'GPS DESATIVADO',
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ],
                ),
              )
      ],
    );
  }

  void goOnline() async {
    Geofire.initialize('driversAvailable');
    if (currentPosition == null) {
      currentPosition = await getCurrentPosition();
    }
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);

    tripRequestRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/newtrip');
    tripRequestRef!.set('waiting');

    tripRequestRef!.onValue.listen((event) {});
  }

  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    tripRequestRef!.onDisconnect();
    tripRequestRef!.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates() {
    homeTabPositionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        currentPosition = position;
      });

      if (isAvailable) {
        Geofire.setLocation(
            currentFirebaseUser!.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController!.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
