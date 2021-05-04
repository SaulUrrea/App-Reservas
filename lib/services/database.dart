import 'package:app_reservas/models/logeo.dart';
import 'package:app_reservas/models/publicaciones.dart';
import 'package:app_reservas/models/solicitud.dart';
import 'package:app_reservas/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Mylogic {
  ValueNotifier<List<Logeo>> nombre = ValueNotifier(null);
  ValueNotifier<List<User>> users = ValueNotifier(null);
  ValueNotifier<List<User>> usuario = ValueNotifier(null);
  ValueNotifier<List<Publicacion>> publicacion = ValueNotifier(null);
  ValueNotifier<List<Publicacion>> servicio = ValueNotifier(null);
  ValueNotifier<List<Publicacion>> servicioBuscado = ValueNotifier(null);
  ValueNotifier<List<Solicitud>> solicitudes = ValueNotifier(null);
  ValueNotifier<List<Solicitud>> reservas = ValueNotifier(null);
  List<Publicacion> categoria;

  void getReservas({String correo_cli}) async {
    final snapshot = await Firestore.instance
        .collection('solicitud')
        .where('correo_cliente', isEqualTo: correo_cli)
        .getDocuments();
    reservas.value =
        snapshot.documents.map((e) => Solicitud.fromMap(e)).toList();
  }

  void getSolicitudes({String correo_emp}) async {
    final snapshot = await Firestore.instance
        .collection('solicitud')
        .where('correo_emprendedor', isEqualTo: correo_emp)
        .where('procesando', isEqualTo: true)
        .getDocuments();
    solicitudes.value =
        snapshot.documents.map((item) => Solicitud.fromMap(item)).toList();
  }

  void getCategoria() async {
    final snapshot =
        await Firestore.instance.collection('publicacion').getDocuments();
    categoria =
        snapshot.documents.map((item) => Publicacion.fromMap(item)).toList();
  }

  void nombreUser() async {
    final snapshot =
        await Firestore.instance.collection('dispositivos').getDocuments();
    nombre.value =
        snapshot.documents.map((item) => Logeo.fromMap(item)).toList();
  }

  void getServicioBuscado({String nombre}) async {
    final snapshot = await Firestore.instance
        .collection('publicacion')
        .where('titulo', isEqualTo: nombre)
        .getDocuments();
    servicioBuscado.value =
        snapshot.documents.map((item) => Publicacion.fromMap(item)).toList();
  }

  void getServicio({String nombre, String categoria}) async {
    final snapshot = await Firestore.instance
        .collection('publicacion')
        .where('busqueda', arrayContains: nombre)
        .where('categoria', isEqualTo: categoria)
        .getDocuments();
    servicio.value =
        snapshot.documents.map((item) => Publicacion.fromMap(item)).toList();
  }

  void getPublicacion() async {
    final snapshot =
        await Firestore.instance.collection('publicacion').getDocuments();

    publicacion.value =
        snapshot.documents.map((item) => Publicacion.fromMap(item)).toList();
  }

  void getUsers() async {
    final snapshot =
        await Firestore.instance.collection('usuarios').getDocuments();
    users.value = snapshot.documents.map((item) => User.fromMap(item)).toList();
  }

  void getUser({String correo}) async {
    final snapshot = await Firestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: correo)
        .getDocuments();
    usuario.value =
        snapshot.documents.map((item) => User.fromMap(item)).toList();
  }

  Future<void> updateUser({String usuario, String imei}) async {
    var map = {'id_usuario': usuario};

    final snapshot = await Firestore.instance.collection('dispositivos');
    return snapshot
        .document(imei)
        .updateData({'id_usuario': usuario})
        .then((value) => print("User Updated ${usuario}"))
        .catchError((value) => Firestore.instance
            .collection('dispositivos')
            .document(imei)
            .setData(map));
  }

  Future<void> updateSolicitudAprovado({String id}) async {
    var map = {
      'procesando': false,
      'aceptado': true,
    };

    final snapshot = await Firestore.instance.collection('solicitud');

    return snapshot
        .document(id)
        .updateData(map)
        .then((value) => print("Estado actualizado"))
        .catchError((value) => Firestore.instance
            .collection('solicitud')
            .document(id)
            .setData(map));
  }

  Future<void> updateSolicitudRechazado({String id}) async {
    var map = {
      'procesando': false,
      'rechazado': true,
    };

    final snapshot = await Firestore.instance.collection('solicitud');
    return snapshot
        .document(id)
        .updateData(map)
        .then((value) => print("Estado actualizado"))
        .catchError((value) => Firestore.instance
            .collection('solicitud')
            .document(id)
            .setData(map));
  }
}
