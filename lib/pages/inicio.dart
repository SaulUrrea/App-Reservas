import 'package:app_reservas/models/solicitud.dart';
import 'package:app_reservas/pages/servicio.dart';
import 'package:app_reservas/search/servicios_search.dart';
import 'package:app_reservas/services/database.dart';
import 'package:app_reservas/services/id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Inicio extends StatefulWidget {
  final String username;
  Inicio({Key key, @required this.username}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final myLogic = Mylogic();
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
    myLogic.getPublicacion();
    super.initState();
    getIMEI();
  }

  @override
  Widget build(BuildContext context) {
    ServiciosSearchDelegate buscar = new ServiciosSearchDelegate();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Buscar',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                showSearch(context: context, delegate: buscar);
              })
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover)),
          child: ValueListenableBuilder(
              valueListenable: myLogic.publicacion,
              builder: (context, publicacion, _) {
                return publicacion != null
                    ? ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: publicacion.length,
                        itemBuilder: (_, index) => Column(
                          children: [
                            _card(
                                titulo: publicacion[index].titulo,
                                categoria: publicacion[index].categoria,
                                descripcion: publicacion[index].descripcion,
                                fechafin: publicacion[index].fechaFin,
                                fechaini: publicacion[index].fechaIni,
                                url: publicacion[index].url,
                                correo_user: publicacion[index].correo),
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      );
              })),
    );
  }

  Widget _card(
      {String titulo,
      String descripcion,
      String fechaini,
      String fechafin,
      String categoria,
      String url,
      String correo_user}) {
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
              title: Text(
                '${titulo}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              subtitle: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Categoria: ${categoria}',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Descripcion: ${descripcion}'),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Fecha de inicio: ${fechaini}'),
                  Text('Fecha de cierre: ${fechafin}'),
                ],
              ),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('${url}'),
              ),
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Servicio(
                            titulo: titulo,
                          )),
                  (Route<dynamic> route) => false)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
              SizedBox(width: 10),
              Icon(
                Icons.access_alarm,
                color: Colors.green,
              ),
              SizedBox(width: 10)
            ],
          )
        ],
      ),
    );
  }
}
