import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:policlinico_flores/models/usuarios_model.dart';
import 'package:policlinico_flores/providers/usuarios_provider.dart';
import 'package:policlinico_flores/ui/bloc/login_bloc.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:policlinico_flores/ui/widgets/inputforms.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Creación de la clase con Widget de estado para Iniciar sesión.
class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Instancias de las clases e inicialización de objetos.
  final UsuarioModel usuarios = UsuarioModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usuarioProvider = UsuariosProvider();
  final bloc = LoginBloc();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: false,
          bottom: false,
          minimum: EdgeInsets.only(top: padding.top),
          child: Stack(
            children: <Widget>[
              //Clase para el fondo de la interfaz con la asignación de los parámetros.
              const FondoForms(
                nameUI: "Login",
                colorfondo: Colors.white,
                colorclip1: Color.fromARGB(255, 0, 108, 223),
                colorclip2: Color.fromARGB(255, 0, 61, 126),
                title: "",
                subtitle: "",
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const ListTile(
                    title: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 23, 60),
                          fontSize: 25,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      "Policlínico Flores",
                      style: TextStyle(color: Color.fromARGB(255, 0, 23, 60)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              _loginForm(context),
            ],
          ),
        ),
      ),
    );
  }

  //Método del Widget que contiene el formulario.
  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: size.height * 0.3, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0.1),
              ],
            ),
            //Widget del formulario con su llave respectiva y llamada a las clases para pasar los datos por parámetros.
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 15),
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 0, 23, 60),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Usuario",
                              style: TextStyle(
                                color: Color(0xFF8F9DB5),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                  ),
                  InputAlternative(
                      getStream: bloc.usuarioController,
                      bloc: bloc.usuarioStream,
                      value: usuarios.usuario,
                      msgError: "Ingrese el usuario.",
                      nameForm: "Login",
                      label: "Usuario",
                      inputHint: "Ingrese su usuario",
                      onSaved: (value) => usuarios.usuario = value,
                      change: bloc.changeUsuario),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 15),
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 0, 23, 60),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Contraseña",
                              style: TextStyle(
                                color: Color(0xFF8F9DB5),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                  ),
                  InputAlternative(
                      getStream: bloc.usuarioController,
                      bloc: bloc.passwordStream,
                      value: usuarios.password,
                      msgError: "Ingrese la contraseña.",
                      nameForm: "Login",
                      label: "Contraseña",
                      inputHint: "Ingrese su contraseña",
                      onSaved: (value) => usuarios.password = value,
                      change: bloc.changePassword),
                  const SizedBox(height: 5),
                  _btnIngresar(context),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "¿No tienes una cuenta?",
                        style: TextStyle(color: Colors.black45, fontSize: 14),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, 'register'),
                          child: const Text("Crear cuenta"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Definición del botón para ingresar
  Widget _btnIngresar(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.formValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            child: const Text(
              "Ingresar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all<Size>(const Size.fromHeight(45)),
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 0, 108, 223),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              elevation: MaterialStateProperty.all(3),
            ),
            onPressed: snapshot.hasData
                ? () {
                    _submit(formKey);
                  }
                : null,
          );
        });
  }

  //Método de para enviar los datos del formulario a la base de datos
  _submit(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState?.save();

    //Llamada a la función de login para almacenar la información del usuario con SharedPrefences.
    await usuarioProvider.login(usuarios).then((usuario) async {
      if (usuario != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_usuario', usuario.idusuario!);
        await prefs.setInt('id_rol', usuario.idrol!);
        await prefs.setString('nombres', usuario.nombres.toString());
        await prefs.setString('apellidos', usuario.apellidos.toString());
        await prefs.setString('email', usuario.email.toString());
        await prefs.setString('usuario', usuario.usuario.toString());
        await prefs.setString('password', usuario.password.toString());

        print("Exito");
        _alertDialog("OK", "Bienvenido(a) " + usuario.usuario.toString(),
            "Policlinico Flores");
      } else {
        _alertDialog(
            "Error", "Error", "El usuario y/o la contraseña son incorrectos.");
      }
      print(await usuarioProvider.usuarios());
    }).catchError((error) {
      print(error);
      print("Error al iniciar sesión");
    });
  }

  //Método para mostrar las alertas.
  _alertDialog(String result, String title, String content) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        if (result == "OK") {
          _timer = Timer(const Duration(seconds: 3), () async {
            Navigator.pop(context, true);
            await Navigator.pushReplacementNamed(context, "principal");
          });
        }
        return CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: result == "OK" ? Colors.blue : Colors.red)),
          content: Text(content,
              style: const TextStyle(
                  fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
          actions: <Widget>[
            result != "OK"
                ? CupertinoDialogAction(
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop("Discard");
                    },
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
