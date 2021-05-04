import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class IdUsuario {
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
  }

  String imei() => _imeiNumber;

  String getCorreo({String imei}) {
    String correo;
    Firestore.instance
        .collection('dispositivos')
        .document(imei)
        .get()
        .then((DocumentSnapshot document) {
      correo = document['id_usuario'];
    });
    return correo;
  }
}
