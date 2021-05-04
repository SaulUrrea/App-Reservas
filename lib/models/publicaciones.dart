import 'package:flutter/cupertino.dart';

class Publicacion {
  final String titulo;
  List<dynamic> busqueda = List();
  final String categoria;
  final String descripcion;
  final String fechaIni;
  final String fechaFin;
  final String correo;
  final String url;
  final List urls;
  final String nombre;

  Publicacion(
      {@required this.titulo,
      @required this.categoria,
      @required this.correo,
      @required this.descripcion,
      @required this.fechaIni,
      @required this.fechaFin,
      @required this.url,
      @required this.urls,
      @required this.nombre,
      @required this.busqueda});

  factory Publicacion.fromMap(dynamic data) {
    return Publicacion(
        nombre: data['nombre'],
        urls: data['urls'],
        correo: data['correo_user'],
        titulo: data['titulo'],
        categoria: data['categoria'],
        descripcion: data['descripcion'],
        fechaIni: data['fechaini'],
        fechaFin: data['fechafin'],
        busqueda: data['busqueda'],
        url: data['url']);
  }

  Map<String, dynamic> toJason() => {
        'nombre': nombre,
        'correo_user': correo,
        'categoria': categoria,
        'descripcion': descripcion,
        'fechafin': fechaFin,
        'fechaini': fechaIni,
        'titulo': titulo,
        'busqueda': busqueda,
        'url': url,
        'urls': urls
      };
}
