import 'package:app_reservas/pages/home.dart';
import 'package:app_reservas/pages/inicio.dart';
import 'package:app_reservas/pages/servicio.dart';
import 'package:app_reservas/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ServiciosSearchDelegate extends SearchDelegate {
  String user;
  String titulo;
  String categoria;

  ServiciosSearchDelegate({this.user});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = ' ')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => this.close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    titulo = query;

    final myLogic = Mylogic();

    myLogic.getServicio(nombre: query);

    return ValueListenableBuilder(
        valueListenable: myLogic.servicio,
        builder: (context, servicio, _) {
          return servicio != null
              ? ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: servicio.length,
                  itemBuilder: (_, index) => Column(
                    children: [
                      Divider(),
                      ListTile(
                          title: Text('${servicio[index].titulo}'),
                          subtitle: Text('${servicio[index].descripcion}'),
                          trailing: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage('${servicio[index].url}'),
                          ),
                          onTap: () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Servicio(
                                        titulo: servicio[index].titulo,
                                      )),
                              (Route<dynamic> route) => false)),
                      Divider(),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> sugerencias = [
      "Industria textil",
      "Centros de belleza",
      "Comercio",
      "Gastronomia"
    ];

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: sugerencias.length,
      itemBuilder: (_, index) => Column(
        children: [
          Divider(),
          ListTile(
            title: Text('${sugerencias[index]}'),
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }
}
