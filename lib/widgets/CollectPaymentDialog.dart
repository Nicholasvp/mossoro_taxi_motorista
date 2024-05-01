import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/helpers/helpermethods.dart';
import 'package:mossorotaximotorista/widgets/BrandDivier.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';
import 'package:flutter/material.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final double fares;

  CollectPayment({required this.paymentMethod, required this.fares});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text('PAGAMENTO'),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              '\R\$$fares',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'O valor acima é o total das tarifas a serem cobradas do passageiro',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 230,
              child: TaxiButton(
                title: (paymentMethod == 'cash')
                    ? 'RECOLHER DINHEIRO'
                    : 'CONFIRMAR',
                color: BrandColors.colorGreen,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  HelperMethods.enableHomTabLocationUpdates();
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
