import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/datamodels/tripdetails.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/helpers/helpermethods.dart';
import 'package:mossorotaximotorista/screens/newtripspage.dart';
import 'package:mossorotaximotorista/widgets/BrandDivier.dart';
import 'package:mossorotaximotorista/widgets/ProgressDialog.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';
import 'package:mossorotaximotorista/widgets/TaxiOutlineButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;

  NotificationDialog({required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            // Image.asset(
            //   'images/taxi.png',
            //   width: 100,
            // ),
            // SizedBox(
            //   height: 16.0,
            // ),
            Text(
              'NOVA SOLICITAÇÃO DE VIAGEM',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              '${tripDetails.type == 'passenger' ? 'PASSAGEIRO' : 'DOCUMENTO'}',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        tripDetails.pickupAddress,
                        style: TextStyle(fontSize: 18),
                      )))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        tripDetails.destinationAddress,
                        style: TextStyle(fontSize: 18),
                      )))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'RECUSAR',
                        color: BrandColors.colorCampanha,
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      child: TaxiButton(
                        title: 'ACEITAR',
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          checkAvailablity(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailablity(context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Aceitando solicitação',
      ),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/newtrip');
    newRideRef.once().then((DatabaseEvent snapshot) {
      Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = "";
      if (snapshot.snapshot.value != null) {
        thisRideID = snapshot.snapshot.value.toString();
      } else {
        Toast.show("Viagem não encontrada");
      }

      if (thisRideID == tripDetails.rideID) {
        newRideRef.set('accepted');
        HelperMethods.disableHomTabLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTripPage(
                tripDetails: tripDetails,
              ),
            ));
      } else if (thisRideID == 'cancelled') {
        Toast.show(
          "A viagem foi cancelada",
        );
      } else if (thisRideID == 'timeout') {
        Toast.show(
          "A viagem expirou",
        );
      } else {
        Toast.show(
          "Viagem não encontrada",
        );
      }
    });
  }
}
