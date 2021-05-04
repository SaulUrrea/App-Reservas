import 'package:app_reservas/pages/emprendedor.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Mapa extends StatefulWidget {
  String user;
  String dir;
  Mapa({Key key, this.user, this.dir}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  MapboxMapController mapController;
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Mapa'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Formulario(
                              usuario: widget.user,
                            )),
                    (Route<dynamic> route) => false);
              })),
      body: crearMapa(),
      floatingActionButton: Center(
        child: IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              return Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Formulario(
                            usuario: widget.user,
                            dir: 'Carrera 12',
                          )),
                  (Route<dynamic> route) => false);
            }),
      ),
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
    );
  }
}
