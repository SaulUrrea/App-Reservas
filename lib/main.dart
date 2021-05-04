import 'package:app_reservas/pages/publicacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_reservas/pages/servicio.dart';
import 'package:app_reservas/pages/home.dart';
import 'package:app_reservas/pages/login.dart';
import 'package:app_reservas/pages/register.dart';
import 'package:app_reservas/pages/emprendedor.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservas App',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English, no country code
        const Locale('es', 'ES'), // Hebrew, no country code
      ],
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => Login(),
        'register': (BuildContext context) => FormScreen(),
        'home': (BuildContext context) => Home(),
        'formulario': (BuildContext context) => Formulario(),
        'publicacion': (BuildContext context) => PublicacionPage(),
      },
    );
  }
}
