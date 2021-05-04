import 'package:app_reservas/pages/notificaciones.dart';
import 'package:app_reservas/pages/perfil.dart';
import 'package:app_reservas/pages/reservas.dart';
import 'package:app_reservas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_reservas/pages/inicio.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Home extends StatefulWidget {
  String username;
  Home({Key key, @required this.username}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  Mylogic myLogic = new Mylogic();
  String uid = "";
  bool emprendedor;

  Future<void> getUsuario() async {
    await FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        uid = val.uid;
      });
    });
    await Firestore.instance
        .collection('usuarios')
        .document(uid)
        .get()
        .then((DocumentSnapshot document) {
      setState(() {
        emprendedor = document['emprendedor'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUsuario();
  }

  Widget _pagefirts = Inicio();
  int _page = 0;

  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget _selecPag(int page, String user) {
    switch (page) {
      case 0:
        return Inicio(username: user);
        break;
      case 1:
        return Reservas(
          username: user,
        );
        break;
      case 2:
        return Perfil(
          username: user,
        );
        break;
      default:
        return new Container(
          child: Text('No ha seleccionado ninguna pagina'),
        );
    }
  }

  Widget _selecPagEmp(int page, String user) {
    switch (page) {
      case 0:
        return Inicio(username: user);
        break;
      case 1:
        return Reservas(
          username: user,
        );
        break;
      case 2:
        return NotificacionesPage(
          username: user,
        );
        break;
      case 3:
        return Perfil(
          username: user,
        );
        break;
      default:
        return new Container(
          child: Text('No ha seleccionado ninguna pagina'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (emprendedor == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    } else {
      return Scaffold(
          bottomNavigationBar: emprendedor == false
              ? CurvedNavigationBar(
                  key: _bottomNavigationKey,
                  backgroundColor: Colors.cyan[800],
                  items: <Widget>[
                    Icon(Icons.home, size: 30),
                    Icon(Icons.forum, size: 30),
                    Icon(Icons.account_circle, size: 30),
                  ],
                  onTap: (index) {
                    setState(() {
                      _pagefirts = _selecPag(index, widget.username);
                    });
                  },
                )
              : CurvedNavigationBar(
                  key: _bottomNavigationKey,
                  backgroundColor: Colors.cyan[800],
                  items: <Widget>[
                    Icon(Icons.home, size: 30),
                    Icon(Icons.forum, size: 30),
                    Icon(Icons.notifications, size: 30),
                    Icon(Icons.account_circle, size: 30),
                  ],
                  onTap: (index) {
                    setState(() {
                      _pagefirts = _selecPagEmp(index, widget.username);
                    });
                  },
                ),
          body: Container(child: _pagefirts));
    }
  }
}
