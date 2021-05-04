import 'package:app_reservas/models/publicaciones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';

import 'home.dart';

class PublicacionPage extends StatefulWidget {
  String usuario;
  String dir;
  PublicacionPage({Key key, this.usuario, this.dir}) : super(key: key);

  @override
  _PublicacionPageState createState() => _PublicacionPageState();
}

class _PublicacionPageState extends State<PublicacionPage> {
  final textControllerTitulo = TextEditingController();
  final textControllerCategoria = TextEditingController();
  final textControllerDescripcion = TextEditingController();

  List<String> _categoria = [
    "Industria textil",
    "Centros de belleza",
    "Comercio",
    "Gastronomia"
  ];

  Future<void> getCorreo() async {
    await FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        uid = val.uid;
      });
    });
    await Firestore.instance
        .collection('usuarios')
        .document(uid)
        .get()
        .then((DocumentSnapshot document) {
      setState(() {
        nombre = document['nombre'];
        correo = document['correo'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCorreo();
  }

  String correo;
  String uid;
  String _nombre;
  String _info;
  String _ubicacion;
  String _categoriaSelected;
  String fechaini;
  String fechafin;
  String _url;
  List<String> imagenes = ['', '', ''];
  String nombre;

  TextEditingController _mapa = new TextEditingController();
  TextEditingController _inputFielDateController = new TextEditingController();
  TextEditingController _inputFielDateController2 = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onsave(BuildContext context) {
    final titulo = textControllerTitulo.text.trim();

    List<String> caseSearchList = List();

    String temp = "";
    for (int i = 0; i < titulo.length; i++) {
      temp = temp + titulo[i];
      caseSearchList.add(temp);
    }

    final categoria = textControllerCategoria.text.trim();
    final descripcion = textControllerDescripcion.text.trim();
    final publicacion = Publicacion(
        categoria: categoria,
        titulo: titulo,
        descripcion: descripcion,
        fechaIni: fechaini,
        fechaFin: fechafin,
        busqueda: caseSearchList,
        correo: correo,
        url: _url,
        urls: imagenes,
        nombre: nombre);
    Firestore.instance.collection('publicacion').add(publicacion.toJason());
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Home(
                  username: widget.usuario,
                )),
        (Route<dynamic> route) => false);
  }

  Widget _buildnombre() {
    return TextFormField(
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      controller: textControllerTitulo,
      decoration: InputDecoration(
        hintText: "Nombre del servicio",
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
        _nombre = value;
      },
    );
  }

  Widget _buildcategorias() {
    return DropDownField(
      controller: textControllerCategoria,
      hintText: "Seleccione una categoria",
      enabled: true,
      items: _categoria,
      onValueChanged: (value) {
        setState(() {
          _categoriaSelected = value;
        });
      },
    );
  }

  Widget _buildinfo() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: textControllerDescripcion,
      decoration: InputDecoration(
        icon: Icon(Icons.description),
        hintText: "Informacion del servicio",
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
        _info = value;
      },
    );
  }

  Widget _buildDateIni(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputFielDateController,
      decoration: InputDecoration(
          hintText: 'Fecha de inicio',
          labelStyle: TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
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
    DateTime fecha = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));

    if (fecha != null) {
      setState(() {
        fechaini = getDate(fecha).toString();
        _inputFielDateController.text = getDate(fecha);
      });
    }
  }

  Widget _buildDateFin(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputFielDateController2,
      decoration: InputDecoration(
          hintText: 'Fecha del final',
          labelStyle: TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.lightBlueAccent[400], width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 2.0),
              borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.calendar_today, color: Colors.black)),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate2(context);
      },
    );
  }

  _selectDate2(BuildContext context) async {
    DateTime fecha = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));

    if (fecha != null) {
      setState(() {
        fechafin = getDate(fecha).toString();
        _inputFielDateController2.text = getDate(fecha);
      });
    }
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
          child: Text("Publicación",
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
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black26,
                        backgroundImage: NetworkImage('${_url}'),
                        radius: 50,
                        child: IconButton(
                          padding: EdgeInsets.all(70),
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Ingrese el url de la imagen.'),
                                  content: Row(
                                    children: [
                                      Expanded(
                                          child: TextField(
                                        autofocus: true,
                                        decoration: InputDecoration(
                                            hintText:
                                                'https://www.ejemplo.jpeg'),
                                        onChanged: (value) {
                                          setState(() {
                                            _url = value;
                                          });
                                        },
                                      ))
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text('Guardar'),
                                      onPressed: () {
                                        Navigator.of(context).pop(_url);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 35),
                      Text(
                        "Añade un logo del servicio",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildnombre(),
                  SizedBox(height: 20),
                  _buildcategorias(),
                  SizedBox(height: 20),
                  ListTile(
                    trailing: Icon(Icons.image),
                    title: Text(
                      'Añade fotos de catalogo',
                    ),
                    onTap: () => _addImage(),
                  ),
                  _buildinfo(),
                  SizedBox(height: 20),
                  _buildDateIni(context),
                  SizedBox(height: 20),
                  _buildDateFin(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          shape: StadiumBorder(),
                          splashColor: Colors.blue,
                          color: Colors.green[300],
                          onPressed: () => onsave(context),
                          child: Text(
                            'Publicar',
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

  getDate(DateTime inputVal) {
    String processedDate;
    processedDate = inputVal.year.toString() +
        '-' +
        inputVal.month.toString() +
        '-' +
        inputVal.day.toString();
    return processedDate;
  }

  _addImage() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Ingrese el url de la imagen.'),
          content: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    decoration:
                        InputDecoration(hintText: 'https://www.ejemplo.jpeg'),
                    onChanged: (value) {
                      if (value != null || value != "") {
                        setState(() {
                          imagenes[0] = value;
                        });
                      }
                      if (value == null) {
                        setState(() {
                          imagenes[0] = 'https://i.imgur.com/uwl7l7K.png';
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    autofocus: true,
                    decoration:
                        InputDecoration(hintText: 'https://www.ejemplo.jpeg'),
                    onChanged: (value) {
                      if (value != null || value != "") {
                        setState(() {
                          imagenes[1] = value;
                        });
                      }
                      if (value == null) {
                        setState(() {
                          imagenes[1] = 'https://i.imgur.com/uwl7l7K.png';
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    autofocus: true,
                    decoration:
                        InputDecoration(hintText: 'https://www.ejemplo.jpeg'),
                    onChanged: (value) {
                      if (value != null || value != "") {
                        setState(() {
                          imagenes[2] = value;
                        });
                      }
                      if (value == "") {
                        setState(() {
                          imagenes[2] = 'https://i.imgur.com/uwl7l7K.png';
                        });
                      }
                    },
                  ),
                ],
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Guardar'),
              onPressed: () {
                Navigator.of(context).pop(imagenes);
              },
            ),
          ],
        );
      },
    );
  }
}
