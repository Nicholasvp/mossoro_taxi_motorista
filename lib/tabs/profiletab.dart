import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/screens/login.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Image(
              alignment: Alignment.center,
              height: 150.0,
              width: 150.0,
              image: AssetImage('images/user_icon.png'),
            ),
            SizedBox(height: 20),
            Text(
              currentDriverInfo!.fullName,
              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 16),
            Text(
              currentDriverInfo!.phone,
              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 14),
            Text(
              currentDriverInfo!.vehicleModel,
              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 14),
            Text(
              currentDriverInfo!.vehicleColor,
              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 14),
            Text(
              currentDriverInfo!.vehicleNumber,
              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TaxiButton(
                color: BrandColors.colorCampanha,
                title: 'Sair',
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.id, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
