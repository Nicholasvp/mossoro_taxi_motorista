import 'dart:async';
import 'dart:io';

import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/datamodels/tripdetails.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/widgets/CollectPaymentDialog.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:mossorotaximotorista/helpers/helpermethods.dart';
import 'package:mossorotaximotorista/helpers/mapkithelper.dart';
import 'package:mossorotaximotorista/widgets/ProgressDialog.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NewTripPage extends StatefulWidget {
  final TripDetails tripDetails;
  NewTripPage({required this.tripDetails});
  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  GoogleMapController? rideMapController;
  Completer<GoogleMapController> _controller = Completer();
  double mapPaddingBottom = 0;

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polyLines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  var locationSettings =
      LocationSettings(accuracy: LocationAccuracy.bestForNavigation);

  BitmapDescriptor? movingMarkerIcon;

  Position? myPosition;

  String status = 'accepted';

  String durationString = '';

  bool isRequestingDirection = false;

  String buttonTitle = 'CHEGOU';

  Color buttonColor = BrandColors.colorGreen;

  Timer? timer;

  int durationCounter = 0;

  void createMarker() {
    if (movingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              (Platform.isIOS)
                  ? 'images/car_ios.png'
                  : 'images/car_android.png')
          .then((icon) {
        movingMarkerIcon = icon;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    acceptTrip();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
            mapType: MapType.normal,
            circles: _circles,
            markers: _markers,
            polylines: _polyLines,
            initialCameraPosition: googlePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              rideMapController = controller;

              setState(() {
                mapPaddingBottom = (Platform.isIOS) ? 255 : 260;
              });

              var currentLatLng =
                  LatLng(currentPosition!.latitude, currentPosition!.longitude);
              var pickupLatLng = widget.tripDetails.pickup;
              await getDirection(currentLatLng, pickupLatLng);

              getLocationUpdates();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  )
                ],
              ),
              height: 280,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      durationString,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Brand-Bold',
                          color: BrandColors.colorPrimary),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.tripDetails.riderName,
                          style:
                              TextStyle(fontSize: 22, fontFamily: 'Brand-Bold'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            child: Icon(Icons.call),
                            onTap: () async {
                              String url =
                                  'tel:${widget.tripDetails.riderPhone}';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/pickicon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.tripDetails.pickupAddress,
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/desticon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.tripDetails.destinationAddress,
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TaxiButton(
                      title: buttonTitle,
                      color: buttonColor,
                      onPressed: () async {
                        if (status == 'accepted') {
                          status = 'arrived';
                          rideRef!.child('status').set(('arrived'));

                          setState(() {
                            buttonTitle = 'INICIAR VIAGEM';
                            buttonColor = BrandColors.colorPrimary;
                          });

                          HelperMethods.showProgressDialog(context);

                          await getDirection(widget.tripDetails.pickup,
                              widget.tripDetails.destination);

                          Navigator.pop(context);
                        } else if (status == 'arrived') {
                          status = 'ontrip';
                          rideRef!.child('status').set('ontrip');

                          setState(() {
                            buttonTitle = 'FINALIZAR VIAGEM';
                            buttonColor = Colors.red[900]!;
                          });

                          startTimer();
                        } else if (status == 'ontrip') {
                          endTrip();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void acceptTrip() {
    String rideID = widget.tripDetails.rideID;
    rideRef = FirebaseDatabase.instance.ref().child('rideRequest/$rideID');

    rideRef!.child('status').set('accepted');
    rideRef!.child('driver_name').set(currentDriverInfo!.fullName);
    rideRef!.child('vehicle_details').set(
        '${currentDriverInfo!.vehicleColor} - ${currentDriverInfo!.vehicleModel}');
    rideRef!.child('driver_phone').set(currentDriverInfo!.phone);
    rideRef!.child('driver_id').set(currentDriverInfo!.id);

    Map locationMap = {
      'latitude': currentPosition!.latitude.toString(),
      'longitude': currentPosition!.longitude.toString(),
    };

    rideRef!.child('driver_location').set(locationMap);

    DatabaseReference historyRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/history/$rideID');
    historyRef.set(true);
  }

  void getLocationUpdates() {
    LatLng oldPosition = LatLng(0, 0);

    ridePositionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(oldPosition.latitude,
          oldPosition.longitude, pos.latitude, pos.longitude);

      print('my rotation = $rotation');

      Marker movingMaker = Marker(
          markerId: MarkerId('moving'),
          position: pos,
          icon: movingMarkerIcon!,
          rotation: rotation.toDouble(),
          infoWindow: InfoWindow(title: 'Current Location'));

      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 17);
        rideMapController!.animateCamera(CameraUpdate.newCameraPosition(cp));

        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingMaker);
      });

      oldPosition = pos;

      updateTripDetails();

      Map locationMap = {
        'latitude': myPosition!.latitude.toString(),
        'longitude': myPosition!.longitude.toString(),
      };

      rideRef!.child('driver_location').set(locationMap);
    });
  }

  void updateTripDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;

      if (myPosition == null) {
        return;
      }

      var positionLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng destinationLatLng;

      if (status == 'accepted') {
        destinationLatLng = widget.tripDetails.pickup;
      } else {
        destinationLatLng = widget.tripDetails.destination;
      }

      var directionDetails = await HelperMethods.getDirectionDetails(
          positionLatLng, destinationLatLng);

      if (directionDetails != null) {
        print(directionDetails.durationText);

        setState(() {
          durationString = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  Future<void> getDirection(
      LatLng pickupLatLng, LatLng destinationLatLng) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Por favor, aguarde...',
            ));

    var thisDetails = await HelperMethods.getDirectionDetails(
        pickupLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails!.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polyLines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: BrandColors.colorPrimary,
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLines.add(polyline);
    });

    // make polyline to fit into the map

    LatLngBounds bounds;

    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    rideMapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: BrandColors.colorPrimary,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorPrimary,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorPrimary,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorPrimary,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void endTrip() async {
    timer!.cancel();

    HelperMethods.showProgressDialog(context);

    if (myPosition == null) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      myPosition = position;
    }

    var currentLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);

    var directionDetails = await HelperMethods.getDirectionDetails(
        widget.tripDetails.pickup, currentLatLng);

    Navigator.pop(context);

    double fares =
        HelperMethods.estimateFares(directionDetails!, durationCounter);

    rideRef!.child('fares').set(fares.toString());

    rideRef!.child('status').set('ended');

    ridePositionStream!.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CollectPayment(
              paymentMethod: widget.tripDetails.paymentMethod,
              fares: fares,
            ));

    HelperMethods.enableHomTabLocationUpdates();

    topUpEarnings(fares);

    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (BuildContext context) {
          return RatingDialog(
            // set your own image/icon widget
            title: Text("Avalie o seu passageiro:"),
            message: Text("Toque em uma estrela e deixe sua avaliação."),
            onSubmitted: (nota) {
              print("onSubmitPressed: nota = $nota");
              // TODO: open the app's page on Google Play / Apple App Store
            },
            submitButtonText: 'ENVIAR',
          );
        });
  }

  void topUpEarnings(double fares) {
    DatabaseReference earningsRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/earnings');
    earningsRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        double oldEarnings = double.parse(snapshot.snapshot.value.toString());

        double adjustedEarnings = (fares.toDouble() * 0.85) + oldEarnings;

        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      } else {
        double adjustedEarnings = (fares.toDouble() * 0.85);
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }
    });
  }
}
