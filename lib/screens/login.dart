import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/screens/mainpage.dart';
import 'package:mossorotaximotorista/screens/registration.dart';
import 'package:mossorotaximotorista/screens/resetpasswordpage.dart';
import 'package:mossorotaximotorista/widgets/ProgressDialog.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Autenticando...',
      ),
    );

    
    final User? user = (await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex) {
        Navigator.pop(context);
        if (ex.code == "user-not-found") {
          showSnackBar('Usuário não encontrado.');
        } else if (ex.code == "invalid-email") {
          showSnackBar('E-mail inválido.');
        } else if (ex.code == 'wrong-password') {
          showSnackBar('Senha inválida.');
        } else {
          showSnackBar(ex.toString());
        }
    })).user;
    if (user != null) {
      // verify login
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('drivers/${user.uid}');
      userRef.once().then((DatabaseEvent snapshot) {
        if (snapshot.snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => false);
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          showSnackBar(
              "Usuário cadastrado como passageiro. Para acessar realize seu cadastro como motorista.");
        }
      });
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
                  'Entrar no Mossoró-Táxi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Text(
                  'Motorista',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
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
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                        title: 'ENTRAR',
                        color: BrandColors.colorCampanha,
                        onPressed: () async {
                          //check network availability

                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult[0] != ConnectivityResult.mobile &&
                              connectivityResult[0] != ConnectivityResult.wifi) {
                            showSnackBar('Sem conexão com internet.');
                            return;
                          }

                          if (emailController.text.isEmpty) {
                            showSnackBar('E-mail não pode estar vazio.');
                            return;
                          }
                          if (passwordController.text.isEmpty) {
                            showSnackBar('Senha não pode estar vazio.');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Por favor insira um endereço de e-mail válido.');
                            return;
                          }

                          if (passwordController.text.length < 6) {
                            showSnackBar('Por favor insira uma senha válida.');
                            return;
                          }

                          login();
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
                        context, RegistrationPage.id, (route) => false);
                  },
                  child: Text('Não possui cadastro? Registrar-se'),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: BrandColors.colorCampanha,
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage())),
                    child: Text('Esqueceu Senha')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
