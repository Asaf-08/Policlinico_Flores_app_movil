import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/usuarios_model.dart';
import 'package:policlinico_flores/providers/usuarios_provider.dart';
import 'package:policlinico_flores/ui/bloc/register_bloc.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:policlinico_flores/ui/widgets/inputforms.dart';

//Creación de la clase con Widget de estado para el registro de cuenta de la aplicación.
class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Instancias de las clases.
  final UsuarioModel usuarios = UsuarioModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usuarioProvider = UsuariosProvider();
  final bloc = RegisterBloc();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Row(children: const <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: BackButton(color: Colors.black))
        ]),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        minimum: EdgeInsets.only(top: padding.top),
        child: Stack(
          children: <Widget>[
            //Clase para el fondo de la interfaz con la asignación de los parámetros.
            const FondoForms(
              nameUI: "Register",
              colorfondo: Colors.white,
              colorclip1: Color.fromARGB(255, 0, 108, 223),
              colorclip2: Color.fromARGB(255, 0, 61, 126),
              title: '',
              subtitle: '',
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 50, left: 40),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    child: const ListTile(
                      title: Text(
                        "Crear cuenta",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 23, 60),
                            fontSize: 25,
                            fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text("Policlínico Flores",
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 23, 60))),
                    ),
                  ),
                ),
              ],
            ),
            _registerForm(context),
          ],
        ),
      ),
    );
  }

  //Método del Widget que contiene el formulario.
  Widget _registerForm(BuildContext context) {
    //Variable final para obtener las dimensiones del dispositivo.
    final size = MediaQuery.of(context).size;

    //Widget que contiene los campos del formulario.
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: size.height * 0.20, left: 20, right: 20),
            padding:
                const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0)),
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
                  InputAlternative(
                    getStream: bloc.nombresController,
                    bloc: bloc.nombresStream,
                    value: usuarios.nombres,
                    msgError: "Ingrese su nombre.",
                    nameForm: "Register",
                    label: "Nombres",
                    inputHint: "",
                    onSaved: (value) => usuarios.nombres = value,
                    change: bloc.changeNombres,
                  ),
                  InputAlternative(
                    getStream: bloc.apellidosController,
                    bloc: bloc.apellidosStream,
                    value: usuarios.apellidos,
                    msgError: "Ingrese sus apellidos.",
                    nameForm: "Register",
                    label: "Apellidos",
                    inputHint: "",
                    onSaved: (value) => usuarios.apellidos = value,
                    change: bloc.changeApellidos,
                  ),
                  InputAlternative(
                    getStream: bloc.usuarioController,
                    bloc: bloc.usuarioStream,
                    value: usuarios.usuario,
                    msgError: "Ingrese el usuario.",
                    nameForm: "Register",
                    label: "Usuario",
                    inputHint: "",
                    onSaved: (value) => usuarios.usuario = value,
                    change: bloc.changeUsuario,
                  ),
                  InputAlternative(
                    getStream: bloc.emailController,
                    bloc: bloc.emailStream,
                    value: usuarios.email,
                    msgError: "Ingrese el email.",
                    nameForm: "Register",
                    label: "Email",
                    inputHint: "",
                    onSaved: (value) => usuarios.email = value,
                    change: bloc.changeEmail,
                  ),
                  InputAlternative(
                    getStream: null,
                    bloc: bloc.passwordStream,
                    value: usuarios.password,
                    msgError: "Ingrese la contraseña.",
                    nameForm: "Register",
                    label: "Contraseña",
                    inputHint: "",
                    onSaved: (value) => usuarios.password = value,
                    change: bloc.changePassword,
                  ),
                  InputAlternative(
                    getStream: null,
                    bloc: bloc.confirmpassStream,
                    value: usuarios.password,
                    msgError: "Confirme la contraseña.",
                    nameForm: "Register",
                    label: "Confirmar contraseña",
                    inputHint: "",
                    onSaved: null,
                    change: bloc.changeConfirmPass,
                  ),
                  const SizedBox(height: 5),
                  _btnCreate(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Definición del método para el botón de crear cuenta.
  Widget _btnCreate(BuildContext context) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            child: const Text(
              "Crear cuenta",
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

  //Método de para enviar los datos del formulario a la base de datos.
  _submit(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState?.save();

    //Llamada a la función de insertar validando la información
    await usuarioProvider.insert(usuarios).then((result) {
      if (result == "OK") {
        _showSnackBar(context, Colors.green, "Registrado correctamente.");
      } else {
        _alertDialog("Error", result);
      }
    }).catchError((error) {
      print(error);
      _alertDialog("Error", "Error al registrarse");
    });

    print(await usuarioProvider.usuarios());
  }

  //Método para mostrar un mensaje sobre la inserción o actualización mediante un SnackBar.
  void _showSnackBar(BuildContext context, Color color, String msg) async {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        msg,
        style: const TextStyle(fontFamily: "Poppins"),
      ),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Aceptar',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    Navigator.pushReplacementNamed(context, "login");
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Método para mostrar las alertas.
  _alertDialog(String title, String content) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.red)),
        content: Text(content,
            style: const TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text(
              "Aceptar",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop("Discard");
            },
          ),
        ],
      ),
    );
  }
}
