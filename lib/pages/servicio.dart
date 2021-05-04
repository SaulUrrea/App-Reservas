import 'package:app_reservas/models/solicitud.dart';
import 'package:app_reservas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:imei_plugin/imei_plugin.dart';

import 'home.dart';

class Servicio extends StatefulWidget {
  final String titulo;
  Servicio({Key key, this.titulo}) : super(key: key);

  @override
  _ServicioState createState() => _ServicioState();
}

class _ServicioState extends State<Servicio> {
  final myLogic = Mylogic();
  String username;
  String correo;
  String _imeiNumber;

  Future<void> getIMEI() async {
    String imeiNumber;
    try {
      imeiNumber =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      imeiNumber = "Fallo a la hora de obtener el IMEI";
    }

    _imeiNumber = imeiNumber;

    await Firestore.instance
        .collection('dispositivos')
        .document(_imeiNumber)
        .get()
        .then((DocumentSnapshot document) {
      setState(() {
        correo = document['id_usuario'];
      });
    });
  }

  void onSave({String correo_emprendedor, String titulo_servicio}) async {
    final snapshot = await Firestore.instance.collection('solicitud');
    final idsolicitud = snapshot.document().documentID;
    final solicitud = Solicitud(
        correo_cliente: correo,
        correo_emprendedor: correo_emprendedor,
        titulo_servicio: titulo_servicio,
        aceptado: false,
        procesando: true,
        rechazado: false,
        id: idsolicitud);
    snapshot.document(idsolicitud).setData(solicitud.toJason());
  }

  @override
  void initState() {
    myLogic.getServicioBuscado(nombre: widget.titulo);
    super.initState();
    getIMEI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Home(
                          username: username,
                        )),
                (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          '                  Servicio',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover)),
        child: Center(
            child: ValueListenableBuilder(
                valueListenable: myLogic.servicioBuscado,
                builder: (context, servicioBuscado, _) {
                  return servicioBuscado != null
                      ? ListView.builder(
                          itemCount: servicioBuscado.length,
                          itemBuilder: (_, index) => Column(
                            children: [
                              _card(
                                  titulo: servicioBuscado[index].titulo,
                                  categoria: servicioBuscado[index].categoria,
                                  descripcion:
                                      servicioBuscado[index].descripcion,
                                  fechafin: servicioBuscado[index].fechaFin,
                                  fechaini: servicioBuscado[index].fechaIni,
                                  url: servicioBuscado[index].url,
                                  urls: servicioBuscado[index].urls,
                                  nombre: servicioBuscado[index].nombre,
                                  correo_user: servicioBuscado[index].correo)
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        );
                })),
      ),
    );
  }

  Widget _card(
      {String titulo,
      String descripcion,
      String fechaini,
      String fechafin,
      String categoria,
      String url,
      List urls,
      String nombre,
      String correo_user}) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 5.0,
      color: Colors.white54,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: CircleAvatar(
                foregroundColor: Colors.red,
                radius: 30,
                backgroundImage: NetworkImage('${url}')),
            title: Text(
              '${titulo}',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            subtitle: Text(
              'Publicacion realizada por: ${nombre}',
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 200,
            width: 350,
            child: Swiper(
              itemCount: 3,
              pagination: new SwiperPagination(
                  builder: new DotSwiperPaginationBuilder(
                      color: Colors.black87,
                      activeColor: Colors.greenAccent,
                      activeSize: 10,
                      size: 8,
                      space: 10)),
              itemBuilder: (BuildContext context, int i) {
                Widget imagenes;
                if (urls[i] == null) {
                  imagenes = Image(
                      image: NetworkImage('https://i.imgur.com/uwl7l7K.png'));
                } else {
                  imagenes = Image(image: NetworkImage('${urls[i]}'));
                }
                i = i + 1;
                return imagenes;
              },
            ),
          ),
          ListTile(
            subtitle: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text('Categoria: ${categoria}.',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                Text('Descripcion: ${descripcion}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(
                  height: 10,
                ),
                Text('Fecha de inicio: ${fechaini}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text('Fecha de cierre: ${fechafin}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                  shape: StadiumBorder(),
                  splashColor: Colors.blue,
                  color: Colors.green[500],
                  onPressed: () {
                    return correo_user == correo
                        ? showDialog(
                            context: context,
                            builder: (buildcontext) {
                              return AlertDialog(
                                title: Text("Reserva fallida."),
                                content: Text(
                                    "No se puede reservar en su propio servicio."),
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
                                            fontSize: 15, color: Colors.white),
                                      ))
                                ],
                              );
                            })
                        : showDialog(
                            context: context,
                            builder: (buildcontext) {
                              return AlertDialog(
                                title: Text("Reserva realizada con exito! "),
                                content: Text(
                                    "Pronto el emprendedor se pondra en contacto con usted."),
                                actions: <Widget>[
                                  FlatButton(
                                      shape: StadiumBorder(),
                                      splashColor: Colors.blue,
                                      color: Colors.cyan[300],
                                      onPressed: () {
                                        onSave(
                                            correo_emprendedor: correo_user,
                                            titulo_servicio: titulo);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cerrar',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ))
                                ],
                              );
                            });
                  },
                  child: Text(
                    'Reservar',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
              SizedBox(width: 200),
              Icon(
                Icons.access_alarm,
                color: Colors.black,
              ),
              SizedBox(width: 10)
            ],
          )
        ],
      ),
    );
  }
}
