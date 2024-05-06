import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mossorotaximotorista/brand_colors.dart';
import 'package:mossorotaximotorista/widgets/TaxiButton.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
 
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

  void resetPassword() async {

    _auth.sendPasswordResetEmail(email: emailController.text).catchError((ex) {
      if (ex.code == "user-not-found") {
        showSnackBar('Usuário não encontrado.');
      } else if (ex.code == "invalid-email") {
        showSnackBar('E-mail inválido.');
      }
    })
    .then((value) {
      showSnackBar('Enviado e-mail de recuperação de senha.');
      Navigator.of(context).pop();
    });  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.colorCampanha,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontFamily: 'Brand-Bold',
          color: Colors.white
        ),
        foregroundColor: Colors.white,
        title: Text('Esqueceu Senha'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Redefinir senha',
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
                        title: 'ENVIAR',
                        color: BrandColors.colorCampanha,
                        onPressed: () async {
                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Por favor, forneça um endereço de e-mail válido');
                            return;
                          }
                          resetPassword();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),  
          ),
        ),
      ),
    );
  }
}
