import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/dataprovider.dart';
import 'package:mossorotaximotorista/helpers/helpermethods.dart';
import 'package:mossorotaximotorista/screens/historypage.dart';
import 'package:mossorotaximotorista/widgets/BrandDivier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTab extends StatefulWidget {
  @override
  _EarningsTabState createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  @override
  void initState() {
    super.initState();
    HelperMethods.getHistoryInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorCampanha,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  'Total Viagens',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${Provider.of<AppData>(context).tripPassengerCount + Provider.of<AppData>(context).tripDocumentCount}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                )
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryPage(type: 'passenger')));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                SizedBox(
                  child: Icon(Icons.people,
                      size: 50, color: BrandColors.colorCampanha),
                  width: 70,
                  height: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Passageiros',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: Container(
                        child: Text(
                  Provider.of<AppData>(context).tripPassengerCount.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 18),
                ))),
              ],
            ),
          ),
        ),
        BrandDivider(),
/*         TaxiButton(
          color: BrandColors.colorCampanha,
          title: 'Sair',
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.id, (route) => false);
          },
        ), */
        /* FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryPage(type: 'document')));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                SizedBox(
                  child: Icon(Icons.email,
                      size: 50, color: BrandColors.colorCampanha),
                  width: 70,
                  height: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Documentos',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: Container(
                        child: Text(
                  Provider.of<AppData>(context).tripDocumentCount.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 18),
                ))),
              ],
            ),
          ),
        ), */
      ],
    );
  }
}
