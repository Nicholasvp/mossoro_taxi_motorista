import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/screens/mainpage.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum VehicleType { car, motorcycle }

class VehicleInfoPage extends StatefulWidget {
  static const String id = 'vehicleinfo';

  @override
  _VehicleInfoPageState createState() => _VehicleInfoPageState();
}

class _VehicleInfoPageState extends State<VehicleInfoPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  VehicleType vehicleType = VehicleType.car;

  var vehicleModelController = TextEditingController();

  var vehicleColorController = TextEditingController();

  var vehicleNumberController = TextEditingController();

  void updateProfile(context) {
    String id = currentFirebaseUser!.uid;
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child('drivers/$id/vehicle_details');

    Map map = {
      'vehicle_type': vehicleType.toString().split('.').last,
      'vehicle_color': vehicleColorController.text,
      'vehicle_model': vehicleModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);

    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Image.asset(
                'images/logo.png',
                height: 150,
                width: 150,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Insira os dados do veículo',
                      style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // create radio group car or motorcycle column
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Radio(
                          value: VehicleType.car,
                          groupValue: vehicleType,
                          onChanged: (value) {
                            setState(() {
                              vehicleType = value!;
                            });
                          },
                        ),
                        Text(
                          'Carro',
                          style:
                              TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                        ),
                        Radio(
                          value: VehicleType.motorcycle,
                          groupValue: vehicleType,
                          onChanged: (value) {
                            setState(() {
                              vehicleType = value!;
                            });
                          },
                        ),
                        Text(
                          'Moto',
                          style:
                              TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: vehicleModelController,
                      keyboardType: TextInputType.text,
                      cursorColor: BrandColors.colorCampanha,
                      decoration: InputDecoration(
                          labelText: 'Modelo',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: BrandColors.colorCampanha),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: BrandColors.colorCampanha),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: vehicleColorController,
                      cursorColor: BrandColors.colorCampanha,
                      decoration: InputDecoration(
                          labelText: 'Cor',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: BrandColors.colorCampanha),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: BrandColors.colorCampanha),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: vehicleNumberController,
                      maxLength: 11,
                      cursorColor: BrandColors.colorCampanha,
                      decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Placa',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: BrandColors.colorCampanha),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: BrandColors.colorCampanha),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 40.0),
                    TaxiButton(
                      color: BrandColors.colorCampanha,
                      title: 'CONTINUAR',
                      onPressed: () {
                        if (vehicleModelController.text.length < 3) {
                          showSnackBar('Forneça um modelo válido.');
                          return;
                        }

                        if (vehicleColorController.text.length < 3) {
                          showSnackBar('Por favor, forneça uma cor válida.');
                          return;
                        }

                        if (vehicleNumberController.text.length < 3) {
                          showSnackBar('Por favor, forneça uma placa válida.');
                          return;
                        }

                        updateProfile(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
