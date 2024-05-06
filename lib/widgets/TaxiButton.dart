import 'package:flutter/material.dart';
import 'package:mossorotaximotorista/brand_colors.dart';

class TaxiButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  TaxiButton(
      {required this.title, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BrandColors.colorCampanha,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),      
      ),
    );
  }
}
