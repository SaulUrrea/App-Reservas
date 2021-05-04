import 'package:flutter/cupertino.dart';

class User {
  final String nombre;
  final String correo;
  final dynamic fecha;
  final String url;
  final bool emprendedor;

  User(
      {@required this.nombre,
      @required this.correo,
      @required this.fecha,
      @required this.emprendedor,
      @required this.url});

  factory User.fromMap(dynamic data) {
    return User(
        nombre: data['nombre'],
        correo: data['correo'],
        url: data['url'],
        emprendedor: data['emprendedor'],
        fecha: data['fecha_nac']);
  }

  String get user {
    return correo;
  }

  Map<String, dynamic> toJason() => {
        'nombre': nombre,
        'correo': correo,
        'fecha_nac': fecha,
        'url': url,
        'emprendedor': emprendedor,
      };
}
