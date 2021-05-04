import 'package:flutter/cupertino.dart';

class Logeo {
  final bool conectado;
  final String id_usuario;
  final String imei;

  Logeo(
      {@required this.conectado,
      @required this.id_usuario,
      @required this.imei});

  factory Logeo.fromMap(dynamic data) {
    return Logeo(
        conectado: data['conectado'],
        id_usuario: data['id_usuario'],
        imei: data['imei']);
  }

  Map<String, dynamic> toJason() => {
        'conectado': conectado,
        'id_usuario': id_usuario,
        'imei': imei,
      };
}
