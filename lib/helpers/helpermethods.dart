import 'dart:math';

import 'package:mossorotaximotorista/datamodels/directiondetails.dart';
import 'package:mossorotaximotorista/datamodels/history.dart';
import 'package:mossorotaximotorista/dataprovider.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/helpers/requesthelper.dart';
import 'package:mossorotaximotorista/widgets/ProgressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      return null;
    }

    return DirectionDetails(
      durationText: response['routes'][0]['legs'][0]['duration']['text'],
      durationValue: response['routes'][0]['legs'][0]['duration']['value'],
      distanceText: response['routes'][0]['legs'][0]['distance']['text'],
      distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
      encodedPoints: response['routes'][0]['overview_polyline']['points'],
    );
  }

  static double estimateFares(DirectionDetails details, int durationValue) {
    // per km = $0.3,
    // per minute = $0.2,
    // base fare = $3,

    double baseFare = 4.50;
    double distanceFare = (details.distanceValue / 1000) * 2.74;
    double timeFare = (details.durationValue / 60) * 0.30;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncateToDouble();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static void disableHomTabLocationUpdates() {
    homeTabPositionStream!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static void enableHomTabLocationUpdates() {
    homeTabPositionStream!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void showProgressDialog(context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Por favor, aguarde',
      ),
    );
  }

  static void getHistoryInfo(context) {
    DatabaseReference earningRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/earnings');

    earningRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    DatabaseReference historyRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/history');
    historyRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values =
            Map<String, dynamic>.from(snapshot.value as Map);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    int tripPassengerCount = 0;
    int tripDocumentCount = 0;
    Provider.of<AppData>(context, listen: false).clearTripDocumentHistory();
    Provider.of<AppData>(context, listen: false).clearTripPassengerHistory();

    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.ref().child('rideRequest/$key');

      historyRef.once().then((DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);

          if (history.type == 'passenger') {
            tripPassengerCount++;
            Provider.of<AppData>(context, listen: false)
                .updateTripPassengerCount(tripPassengerCount);
            Provider.of<AppData>(context, listen: false)
                .updateTripPassengerHistory(history);
          }
          if (history.type == 'document') {
            tripDocumentCount++;
            Provider.of<AppData>(context, listen: false)
                .updateTripDocumentCount(tripDocumentCount);
            Provider.of<AppData>(context, listen: false)
                .updateTripDocumentHistory(history);
          }

          print(history.destination);
        }
      });
    }
  }

  static String formatMyDate(String datestring) {
    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }
}
