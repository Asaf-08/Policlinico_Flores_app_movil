import 'package:flutter/material.dart';
import 'package:policlinico_flores/ui/pages/listas/list_citas_usuario.dart';
import 'package:policlinico_flores/ui/pages/listas/list_fichas.dart';
import 'package:policlinico_flores/ui/pages/citasreserva.dart';
import 'package:policlinico_flores/ui/pages/listas/list_citas.dart';
import 'package:policlinico_flores/ui/pages/listas/list_consultas.dart';
import 'package:policlinico_flores/ui/pages/listas/list_pacientes.dart';
import 'package:policlinico_flores/ui/pages/listas/list_pagos.dart';
import 'package:policlinico_flores/ui/pages/login.dart';
import 'package:policlinico_flores/ui/pages/pagos.dart';
import 'package:policlinico_flores/ui/pages/register.dart';
import 'package:policlinico_flores/ui/widgets/navdrawer.dart';
import 'package:policlinico_flores/ui/controller/classbuilder.dart';
import 'package:policlinico_flores/ui/pages/consultas.dart';
import 'package:policlinico_flores/ui/pages/pacientes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ClassBuilder.registerClasses();
  //Obtener las preferencias compartidas almacenadas para el inicio de sesión
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var usuario = prefs.getString('usuario');
  print(usuario);
  runApp(MyApp(usuario: usuario));
}

class MyApp extends StatelessWidget {
  final String? usuario;
  const MyApp({Key? key, required this.usuario}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Policlinico Flores',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.blue,
      ),
      //Definición de rutas
      initialRoute: usuario == null ? 'login' : 'principal',
      routes: {
        'principal': (BuildContext context) => const Principal(),

        //Nuevos
        'login': (BuildContext context) => Login(),
        'register': (BuildContext context) => Register(),
        'newcita': (BuildContext context) => const Citas(
            title: "Reserva de cita",
            headerColor: Color.fromARGB(255, 0, 108, 223),
            btnText: "Solicitar",
            btnColor: Color.fromARGB(255, 0, 108, 223)),
        'newpaciente': (BuildContext context) => const Pacientes(
            title: "Nuevo paciente",
            headerColor: Color.fromARGB(255, 0, 108, 223),
            btnText: "Guardar",
            btnColor: Color.fromARGB(255, 0, 108, 223)),
        'newconsulta': (BuildContext context) => const Consultas(
            title: "Nueva consulta",
            headerColor: Color.fromARGB(255, 0, 108, 223),
            btnText: "Guardar",
            btnColor: Color.fromARGB(255, 0, 108, 223)),
        'newpago': (BuildContext context) => const Pagos(
            title: "Nuevo pago",
            headerColor: Color.fromARGB(255, 0, 108, 223),
            btnText: "Guardar",
            btnColor: Color.fromARGB(255, 0, 108, 223)),

        //Editar
        'editcita': (BuildContext context) => const Citas(
            title: "Editar cita",
            headerColor: Colors.green,
            btnText: "Actualizar",
            btnColor: Colors.green),
        'editpaciente': (BuildContext context) => const Pacientes(
            title: "Editar Paciente",
            headerColor: Colors.green,
            btnText: "Actualizar",
            btnColor: Colors.green),
        'editconsulta': (BuildContext context) => const Consultas(
            title: "Editar consulta",
            headerColor: Colors.green,
            btnText: "Actualizar",
            btnColor: Colors.green),
        'editpago': (BuildContext context) => const Pagos(
            title: "Editar pago",
            headerColor: Colors.green,
            btnText: "Actualizar",
            btnColor: Colors.green),

        //Listados
        'listcitas': (BuildContext context) => const ListaCitas(),
        'listcitasuser': (BuildContext context) => const ListaCitasUsuario(),
        'listpacientes': (BuildContext context) => const ListaPacientes(),
        'listconsultas': (BuildContext context) => const ListaConsultas(),
        'listpagos': (BuildContext context) => const ListaPagos(),
        'listfichas': (BuildContext context) => const ListaFichas(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
    );
  }
}
