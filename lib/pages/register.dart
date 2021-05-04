import 'package:app_reservas/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_reservas/services/database.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  void onSave() async {
    final name = _nombre;
    final email = _correo.text.trim().toLowerCase();
    final fecha = _fecha;
    final id = uid;
    final user = User(
        nombre: name, correo: email, fecha: fecha, emprendedor: false, url: "");
    await Firestore.instance
        .collection('usuarios')
        .document(id)
        .setData(user.toJason());
    Navigator.pushNamed(context, 'login');
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String uid = '';
  String _nombre;
  String _email;
  String _password;
  String _cpassword;
  String _confi;
  String _fecha;
  TextEditingController _inputFielDateController = new TextEditingController();
  TextEditingController _correo = new TextEditingController();

  bool _verContra = true;
  bool _success;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildNombre() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Nombre',
          hintText: 'Nombre de la persona',
          labelStyle: TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.account_circle, color: Colors.black)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El nombre es requerido.';
        }

        return null;
      },
      onSaved: (String value) {
        _nombre = value;
      },
    );
  }

  ValueNotifier<List<User>> usuario = ValueNotifier(null);

  Widget _buildEmail() {
    return TextFormField(
      controller: _correo,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.black,
              ),
              onPressed: () {}),
          labelText: 'Email',
          hintText: 'Correo Electronico',
          labelStyle: TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.email, color: Colors.black)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El Email es requerido';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Por favor, introduce una dirección de correo electrónico válida';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: _verContra,
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
        labelText: 'Contraseña',
        hintText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.white70),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.lock_open, color: Colors.black),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Se requiere contraseña';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
        _confi = _password;
      },
    );
  }

  Widget _buildcPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirmar Contraseña',
        hintText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.white70),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.lock_open, color: Colors.black),
      ),
      keyboardType: TextInputType.visiblePassword,
      onSaved: (String value) {
        _cpassword = value;
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Se requiere confirmacion de la contraseña';
        }

        if (_cpassword != _confi) {
          return 'Las contraseñas no son correctas';
        }
        return null;
      },
    );
  }

  Widget _buildDate(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputFielDateController,
      decoration: InputDecoration(
          labelText: 'Fecha de nacimiento',
          hintText: 'Fecha de nacimiento',
          labelStyle: TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.calendar_today, color: Colors.black)),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime fechaNaci = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));

    if (fechaNaci != null) {
      setState(() {
        _fecha = getDate(fechaNaci).toString();
        _inputFielDateController.text = getDate(fechaNaci);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fitWidth)),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Registrate',
                      style: TextStyle(color: Colors.black, fontSize: 30)),
                  Text('Es rapido y facil.',
                      style: TextStyle(color: Colors.black, fontSize: 30)),
                  SizedBox(height: 30),
                  _buildNombre(),
                  Divider(),
                  _buildEmail(),
                  Divider(),
                  _buildDate(context),
                  Divider(),
                  _buildPassword(),
                  Divider(),
                  _buildcPassword(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        color: Colors.black,
                        child: Text(
                          'Registrate',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          _formKey.currentState.save();

                          print(_nombre);
                          print(_email);
                          print(_password);
                          print(_cpassword);

                          final FirebaseUser user =
                              (await _auth.createUserWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          ))
                                  .user;

                          if (user != null) {
                            setState(() {
                              _success = true;
                              _email = user.email;
                              print('Registro exitoso');
                            });
                            if (user.email == _email) {
                              print(_email);
                            }
                          } else {
                            setState(() {
                              _success = false;
                              print('Fallo al crear');
                            });
                          }
                          if (_success == true) {
                            return showDialog(
                                context: context,
                                builder: (buildcontext) {
                                  return AlertDialog(
                                    title: Text("Registro exitoso "),
                                    content: Text(
                                        "Pronto podra hacer uso de nuestra app"),
                                    actions: <Widget>[
                                      FlatButton(
                                          shape: StadiumBorder(),
                                          splashColor: Colors.blue,
                                          color: Colors.cyan[300],
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .currentUser()
                                                .then((val) {
                                              setState(() {
                                                uid = val.uid;
                                              });
                                            });
                                            onSave();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cerrar',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ))
                                    ],
                                  );
                                });
                          } else {
                            return showDialog(
                                context: context,
                                builder: (buildcontext) {
                                  return AlertDialog(
                                    title: Text("Fallo al crear cuenta "),
                                    content: Text(
                                        "Pronto un admin se pondra en contacto con usted."),
                                    actions: <Widget>[
                                      FlatButton(
                                          shape: StadiumBorder(),
                                          splashColor: Colors.blue,
                                          color: Colors.cyan[300],
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cerrar',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ))
                                    ],
                                  );
                                });
                          }
                        },
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton(
                          child: Text('Cancelar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pushNamed(context, 'login');
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDate(DateTime inputVal) {
    String processedDate;
    processedDate = inputVal.year.toString() +
        '-' +
        inputVal.month.toString() +
        '-' +
        inputVal.day.toString();
    return processedDate;
  }
}
