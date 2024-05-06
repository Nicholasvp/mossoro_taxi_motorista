import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/globalvariabels.dart';
import 'package:mossorotaximotorista/screens/login.dart';
import 'package:mossorotaximotorista/screens/vehicleinfo.dart';
import 'package:mossorotaximotorista/widgets/ProgressDialog.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var passwordConfirmationController = TextEditingController();

  void registerUser() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Registrando...',
      ),
    );

    final User? user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex) {
      //check error and display message
      Navigator.pop(context);
      if (ex.code == "email-already-in-use") {
        showSnackBar("O endereço de e-mail já está em uso por outra conta.");
      }
    })
    ).user;

    Navigator.pop(context);
    // check if user registration is successful
    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('drivers/${user.uid}');

      //Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);

      currentFirebaseUser = user;

      //Take the user to the mainPage
      Navigator.pushNamed(context, VehicleInfoPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 150.0,
                  width: 150.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Criar Uma Conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // Fullname
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        cursorColor: BrandColors.colorCampanha,
                        decoration: InputDecoration(
                            labelText: 'Nome completo',
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
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: BrandColors.colorCampanha,
                        decoration: InputDecoration(
                            labelText: 'E-mail',
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
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: BrandColors.colorCampanha,
                        decoration: InputDecoration(
                            labelText: 'Telefone',
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
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        cursorColor: BrandColors.colorCampanha,
                        decoration: InputDecoration(
                            labelText: 'Senha',
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
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Password
                      TextField(
                        controller: passwordConfirmationController,
                        obscureText: true,
                        cursorColor: BrandColors.colorCampanha,
                        decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
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
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      TaxiButton(
                        title: 'REGISTRAR',
                        color: BrandColors.colorCampanha,
                        onPressed: () async {
                          //check network availability

                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('Sem conexão com internet.');
                            return;
                          }

                          if (fullNameController.text.length < 3) {
                            showSnackBar('Forneça um nome completo válido');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Por favor, forneça um endereço de e-mail válido');
                            return;
                          }

                          if (phoneController.text.length < 10) {
                            showSnackBar(
                                'Por favor forneça um número de telefone válido');
                            return;
                          }

                          if (passwordController.text.length < 6) {
                            showSnackBar(
                                'A senha deve ter pelo menos 6 caracteres.');
                            return;
                          }

                          if (passwordController.text !=
                              passwordConfirmationController.text) {
                            showSnackBar('Confirmação da senha não confere.');
                            return;
                          }

                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.colorCampanha,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                  },
                  child: Text('Já possui uma conta? Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
