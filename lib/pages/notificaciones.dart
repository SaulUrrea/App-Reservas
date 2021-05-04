import 'package:app_reservas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class NotificacionesPage extends StatefulWidget {
  String username;
  NotificacionesPage({Key key, this.username}) : super(key: key);

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  @override
  final mylogic = Mylogic();
  String correo = "";
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
      mylogic.getSolicitudes(correo_emp: correo);
    });
  }

  @override
  void initState() {
    super.initState();
    getIMEI();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Notificaciones',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover)),
          child: ValueListenableBuilder(
              valueListenable: mylogic.solicitudes,
              builder: (context, solicitudes, _) {
                return solicitudes != null
                    ? ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: solicitudes.length,
                        itemBuilder: (_, index) => Column(
                          children: [
                            _card(
                                titulo: solicitudes[index].titulo_servicio,
                                correo_clien: solicitudes[index].correo_cliente,
                                aprovado: solicitudes[index].aceptado,
                                proceso: solicitudes[index].procesando,
                                rechazado: solicitudes[index].rechazado,
                                id: solicitudes[index].id),
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

  Widget _card({titulo, correo_clien, aprovado, proceso, rechazado, id}) {
    String estado;
    if (aprovado == true) {
      estado = "Aprovado";
    }
    if (proceso == true) {
      estado = "En proceso";
    }
    if (rechazado == true) {
      estado = "Rechazado";
    }
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text('${titulo}'),
            subtitle: Text(
                "Estado de la solicitud: ${estado}\nSolicitud realizada por: ${correo_clien}"),
          ),
          Row(
            children: [
              SizedBox(width: 80),
              FlatButton(
                  color: Colors.greenAccent,
                  onPressed: () {
                    mylogic.updateSolicitudAprovado(id: id);
                  },
                  child: Text('Aprovar')),
              SizedBox(width: 10),
              FlatButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (buildcontext) {
                          return AlertDialog(
                            title: Text("¿Desea rechazar la solicitud?"),
                            content: Text(""),
                            actions: <Widget>[
                              FlatButton(
                                  shape: StadiumBorder(),
                                  splashColor: Colors.blue,
                                  color: Colors.greenAccent,
                                  onPressed: () {
                                    mylogic.updateSolicitudRechazado(id: id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Aceptar',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  )),
                              FlatButton(
                                  shape: StadiumBorder(),
                                  splashColor: Colors.blue,
                                  color: Colors.redAccent,
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
                        });
                  },
                  child: Text('Rechazar')),
            ],
          ),
        ],
      ),
    );
  }
}
