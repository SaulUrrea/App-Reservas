import 'package:app_reservas/models/logeo.dart';
import 'package:app_reservas/models/users.dart';
import 'package:app_reservas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ValueNotifier<List<User>> users = ValueNotifier(null);
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = new RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String _correo;
  String _contrasena;
  String mensaje = '';
  bool _logueado = false;
  bool _verContra = true;
  String _imeiNumber = "";

  @override
  void initState() {
    super.initState();
    getIMEI();
  }

  Future<void> getIMEI() async {
    String imeiNumber;
    try {
      imeiNumber =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      imeiNumber = "Fallo a la hora de obtener el IMEI";
    }

    _imeiNumber = imeiNumber;
  }

  final styleText = TextStyle(color: Colors.black, fontSize: 40);
  final styleTextBot = TextStyle(color: Colors.black, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.cover)),
            child: ListView(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: 100),
                Text('LOGIN', style: styleText),
                SizedBox(height: 40),
                Container(
                  width: 300.0,
                  child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          _inputCorreo(emailRegExp),
                          SizedBox(height: 10),
                          _inputPassword(_contrasena, contRegExp)
                        ],
                      )),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _crearBotonLogin(context, _logueado, _key, mensaje),
                  ],
                ),
                SizedBox(height: 100),
                Text('¿Eres nuevo?',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_crearBotonRegistro(context)],
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
            ])));
  }

  Widget _crearBotonRegistro(context) {
    return RaisedButton(
        color: Colors.black,
        child: Text('Crea tu cuenta', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.pushNamed(context, 'register');
        });
  }

  Widget _crearBotonLogin(context, _logueado, _key, mensaje) {
    return RaisedButton(
        color: Colors.black,
        child: Text('Ingresar', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          try {
            if ((_emailController.text.length != 0) &
                (_passwordController.text.length != 0)) {
              final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              ))
                  .user;

              if (user != null) {
                setState(() {
                  _logueado = true;
                  _correo = user.email;
                });

                Mylogic app = new Mylogic();

                app.updateUser(usuario: _correo, imei: _imeiNumber);

                print('Conectado correctamente');

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Home(
                              username: _correo,
                            )),
                    (Route<dynamic> route) => false);
              } else {
                setState(() {
                  _logueado = false;
                });
                print('Fallo al conectar');
              }
            } else {
              showDialog(
                  context: context,
                  builder: (buildcontext) {
                    return AlertDialog(
                      title: Text("Fallo al iniciar Sesion."),
                      content: Text("Se deben de llenar todos los campos."),
                      actions: <Widget>[
                        RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "CERRAR",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          } on Exception catch (_) {
            return print('Usuario o contraseña incorrecto');
          }
        });
  }

  Widget _inputPassword(_contrasena, contRegExp) {
    return TextFormField(
      controller: _passwordController,
      validator: (text) {
        if (text.length == 0) {
          return "Este campo contraseña es requerido";
        } else if (text.length <= 5) {
          return "Su contraseña debe tener menos 5 caracteres";
        } else if (!contRegExp.hasMatch(text)) {
          return "El formato para contraseña no es correcto";
        }
        return null;
      },
      obscureText: _verContra,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                if (_verContra == true) {
                  _verContra = false;
                } else {
                  _verContra = true;
                }
              });
            }),
        hintText: 'Ingrese su Contraseña',
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.white70),
        counterText: '',
        icon: Icon(Icons.lock, size: 32.0, color: Colors.black87),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
      ),
      onSaved: (text) => _contrasena = text,
    );
  }

  Widget _inputCorreo(emailRegExp) {
    return TextFormField(
      controller: _emailController,
      validator: (text) {
        if (text.length == 0) {
          return "Este campo correo es requerido";
        } else if (!emailRegExp.hasMatch(text)) {
          return "El formato para correo no es correcto";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Ingrese su Correo',
        labelText: 'Correo electronico',
        labelStyle: TextStyle(color: Colors.white70),
        counterText: '',
        icon: Icon(Icons.email, size: 32.0, color: Colors.black),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
      ),
      onSaved: (text) => _correo = text,
    );
  }
}
