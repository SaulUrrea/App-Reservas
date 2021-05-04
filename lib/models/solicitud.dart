import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Solicitud {
  final String id;
  final String correo_cliente;
  final String correo_emprendedor;
  final String titulo_servicio;
  final bool aceptado;
  final bool rechazado;
  final bool procesando;

  Solicitud({
    @required this.id,
    @required this.correo_cliente,
    @required this.correo_emprendedor,
    @required this.titulo_servicio,
    @required this.aceptado,
    @required this.procesando,
    @required this.rechazado,
  });

  factory Solicitud.fromMap(dynamic data) {
    return Solicitud(
        id: data['id'],
        correo_cliente: data['correo_cliente'],
        correo_emprendedor: data['correo_emprendedor'],
        aceptado: data['aceptado'],
        procesando: data['procesando'],
        rechazado: data['rechazado'],
        titulo_servicio: data['titulo_servicio']);
  }

  Map<String, dynamic> toJason() => {
        'id': id,
        'correo_cliente': correo_cliente,
        'correo_emprendedor': correo_emprendedor,
        'aceptado': aceptado,
        'procesando': procesando,
        'rechazado': rechazado,
        'titulo_servicio': titulo_servicio,
      };
}
