import 'package:app_reservas/pages/home.dart';
import 'package:app_reservas/pages/map.dart';
import 'package:flutter/material.dart';

class Formulario extends StatefulWidget {
  String usuario;
  String dir;
  Formulario({Key key, this.usuario, this.dir}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FormularioState();
  }
}

class FormularioState extends State<Formulario> {
  String _servicios;
  String _tipodocumento;
  String _documento;
  String _celular;
  String _direccion;
  TextEditingController _mapa = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildServivio() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El campo es requerido.';
        }

        return null;
      },
      onSaved: (String value) {
        _servicios = value;
      },
    );
  }

  Widget _buildDocumento() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El campo es requerido.';
        }

        return null;
      },
      onSaved: (String value) {
        _documento = value;
      },
    );
  }

  Widget _buildTelefono() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El campo es requerido.';
        }

        return null;
      },
      onSaved: (String value) {
        _celular = value;
      },
    );
  }

  Widget _buildDireccion() {
    _mapa.text = widget.dir;
    return TextFormField(
      controller: _mapa,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(20)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El campo es requerido.';
        }

        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Mapa(
                      user: widget.usuario,
                    )),
            (Route<dynamic> route) => false);
      },
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Envio exitoso "),
            content: Text("Espere revicion"),
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
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Home(
                          username: widget.usuario,
                        )),
                (Route<dynamic> route) => false);
          },
        ),
        title: Center(
          child: Text("Formulario",
              style: TextStyle(color: Colors.black, fontSize: 20)),
        ),
        backgroundColor: Colors.white,
      ),
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
                  Text(
                    '¿Quieres convertirte en un emprendedor?',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text('¿Qué tipos de servicios quieres ofrecer?',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  SizedBox(height: 10),
                  _buildServivio(),
                  Divider(),
                  Text('Documento.',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  SizedBox(height: 10),
                  _buildDocumento(),
                  Divider(),
                  Text('Numero de contacto',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  SizedBox(height: 10),
                  _buildTelefono(),
                  Divider(),
                  Text('Dirección del servicio.',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  SizedBox(height: 10),
                  _buildDireccion(),
                  Divider(),
                  SizedBox(height: 1),
                  Text(
                    'Este formulario será revisado por uno de los administradores de la aplicacion para validar tu aporte',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          shape: StadiumBorder(),
                          splashColor: Colors.blue,
                          color: Colors.green[300],
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();

                            print(_servicios);
                            print(_documento);
                            print(_celular);
                            print(_direccion);
                            _showAlertDialog();
                          },
                          child: Text(
                            'Enviar',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )),
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
}
