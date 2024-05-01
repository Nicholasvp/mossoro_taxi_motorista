// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:mossorotaximotorista/datamodels/tripdetails.dart';
// import 'package:mossorotaximotorista/globalvariabels.dart';
// import 'package:mossorotaximotorista/widgets/NotificationDialog.dart';
// import 'package:mossorotaximotorista/widgets/ProgressDialog.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class PushNotificationService {
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

//   Future initialize(context) async {
//     if (Platform.isIOS) {
//       firebaseMessaging.requestPermission();
//     }

//     firebaseMessaging.getInitialMessage().then(
//           (value) => 
//              {
//               _resolved = true;
//               initialMessage = value?.data.toString();
//             },
          
//         );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       fetchRideInfo(getRideID(message), context);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       fetchRideInfo(getRideID(message), context);
//     });

//     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
//       fetchRideInfo(getRideID(message), context);
//     });
//   }

//   void getToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     print('token: $token');

//     DatabaseReference tokenRef = FirebaseDatabase.instance
//         .reference()
//         .child('drivers/${currentFirebaseUser.uid}/token');
//     tokenRef.set(token);

//     FirebaseMessaging.instance.subscribeToTopic('alldrivers');
//     FirebaseMessaging.instance.subscribeToTopic('allusers');
//   }

//   String getRideID(Map<String, dynamic> message) {
//     String rideID = '';

//     if (Platform.isAndroid) {
//       rideID = message['data']['ride_id'];
//     } else {
//       rideID = message['ride_id'];
//       print('ride_id: $rideID');
//     }

//     return rideID;
//   }

//   void fetchRideInfo(String rideID, context) {
//     //show please wait dialog
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) => ProgressDialog(
//         status: 'Buscando detalhes',
//       ),
//     );

//     DatabaseReference rideRef =
//         FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
//     rideRef.once().then((DataSnapshot snapshot) {
//       Map<dynamic, dynamic> values = Map<String, dynamic>.from(snapshot.value as Map);
//       Navigator.pop(context);

//       if (snapshot.value != null) {
//         assetsAudioPlayer.open(
//           Audio('sounds/alert.mp3'),
//         );
//         assetsAudioPlayer.play();

//         double pickupLat =
//             double.parse(values['location']['latitude'].toString());
//         double pickupLng =
//             double.parse(values['location']['longitude'].toString());
//         String pickupAddress = values['pickup_address'].toString();

//         double destinationLat =
//             double.parse(values['destination']['latitude'].toString());
//         double destinationLng =
//             double.parse(values['destination']['longitude'].toString());
//         String destinationAddress = values['destination_address'];
//         String type = values['type'];
//         String riderName = values['rider_name'];
//         String riderPhone = values['rider_phone'];

//         TripDetails tripDetails = TripDetails(
//           rideID: rideID,
//           pickupAddress: pickupAddress,
//           destinationAddress: destinationAddress,
//           pickup: LatLng(pickupLat, pickupLng),
//           destination: LatLng(destinationLat, destinationLng),
//           type: type,
//           riderName: riderName,
//           riderPhone: riderPhone,
//         );

//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) => NotificationDialog(
//             tripDetails: tripDetails,
//           ),
//         );
//       }
//     });
//   }
// }