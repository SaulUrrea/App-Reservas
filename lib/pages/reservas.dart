import 'package:app_reservas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Reservas extends StatefulWidget {
  final String username;
  Reservas({Key key, @required this.username}) : super(key: key);

  @override
  _ReservasState createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {
  final mylogic = Mylogic();
  bool emprendedor;
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
      mylogic.getReservas(correo_cli: correo);
    });
  }

  @override
  void initState() {
    super.initState();
    getIMEI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Reservas',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
        ),
        child: ValueListenableBuilder(
            valueListenable: mylogic.reservas,
            builder: (context, reservas, _) {
              return reservas != null
                  ? ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: reservas.length,
                      itemBuilder: (_, index) => Column(
                        children: [
                          _card(
                              titulo: reservas[index].titulo_servicio,
                              correo_emp: reservas[index].correo_emprendedor,
                              aprovado: reservas[index].aceptado,
                              proceso: reservas[index].procesando,
                              rechazado: reservas[index].rechazado,
                              id: reservas[index].id),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
            }),
      ),
    );
  }

  _card({titulo, correo_emp, aprovado, proceso, rechazado, id}) {
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
        child: Column(children: [
          ListTile(
            title: Text('Has reservado los servicios de ${titulo}'),
            subtitle: Text(
                "Estado de la solicitud: ${estado}\nSolicitud realizada a: ${correo_emp}"),
          ),
        ]));
  }
}
