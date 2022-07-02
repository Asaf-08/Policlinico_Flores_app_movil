import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/usuarios_model.dart';
import 'package:policlinico_flores/providers/usuarios_provider.dart';
import 'package:policlinico_flores/ui/bloc/register_bloc.dart';
import 'package:policlinico_flores/ui/widgets/buttonforms.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:policlinico_flores/ui/widgets/inputforms.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Creación de la clase con Widget de estado para editar el perfil del usuario.
class Usuarios extends StatefulWidget {
  //Definición de los atributos de la clase.
  final int? idusuario;
  final int? idrol;
  final String? nombres;
  final String? apellidos;
  final String? email;
  final String? usuario;
  final String? password;
  const Usuarios(
      {Key? key,
      required this.idusuario,
      required this.idrol,
      required this.nombres,
      required this.apellidos,
      required this.email,
      required this.usuario,
      required this.password})
      : super(key: key);

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  //Instancias de las clases.
  final UsuarioModel usuario = UsuarioModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usuarioProvider = UsuariosProvider();
  final bloc = RegisterBloc();

  //Método de inicialización.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            //Clase para el fondo de la interfaz con la asignación de los parámetros.
            const FondoForms(
              nameUI: "Forms",
              colorfondo: Color.fromARGB(255, 0, 108, 223),
              colorclip1: Colors.white,
              colorclip2: Color(0xFF333333),
              title: "Mi perfil",
              subtitle: 'Complete la información.',
            ),
            _pacientesForm(context, usuario, formKey),
            SafeArea(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                child: Material(
                  shadowColor: Colors.transparent,
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Método del Widget que contiene el formulario.
  Widget _pacientesForm(BuildContext context, UsuarioModel usuario,
      GlobalKey<FormState> formKey) {
    //Instancia para obtener los argumentos que se pasen a la clase.
    final UsuarioModel? usuData =
        ModalRoute.of(context)!.settings.arguments as UsuarioModel?;

    //Comprobación si existen datos en los argumentos obtenidos.
    if (usuData != null) {
      usuario = usuData;
    }

    //Widget que contiene los campos del formulario.
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(height: 95.0),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -10),
                    spreadRadius: 0.1),
              ],
            ),
            //Widget del formulario con su llave respectiva y llamada a las clases para pasar los datos por parámetros.
            child: Form(
              key: formKey,
              child: Column(children: <Widget>[
                const SizedBox(height: 20),
                CustomInputForm(
                  bloc: bloc.nombresStream,
                  value: widget.nombres,
                  lblText: "Nombres",
                  msgError: "Ingrese su nombre.",
                  onSaved: (value) => usuario.nombres = value,
                  change: bloc.changeNombres,
                ),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.apellidosStream,
                  value: widget.apellidos,
                  lblText: "Apellidos",
                  msgError: "Ingrese sus apellido.",
                  onSaved: (value) => usuario.apellidos = value,
                  change: bloc.changeApellidos,
                ),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.emailStream,
                  value: widget.email,
                  lblText: "Email",
                  msgError: "Ingrese el email.",
                  onSaved: (value) => usuario.email = value,
                  change: bloc.changeEmail,
                ),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.usuarioStream,
                  value: widget.usuario,
                  lblText: "Usuario",
                  msgError: "Ingrese el usuario.",
                  onSaved: (value) => usuario.usuario = value,
                  change: bloc.changeUsuario,
                ),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.passwordStream,
                  value: widget.password,
                  lblText: "Contraseña",
                  msgError: "Ingrese la contraseña.",
                  onSaved: (value) => usuario.password = value,
                  change: bloc.changePassword,
                ),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.confirmpassStream,
                  value: "",
                  lblText: "Confirmar contraseña",
                  msgError: "Confirme la contraseña.",
                  onSaved: null,
                  change: bloc.changeConfirmPass,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 100),
                    Expanded(
                      child: CustomButtonForm(
                        bloc: null,
                        text: "Cancelar",
                        color: const Color(0xFF515151),
                        onPressed: () {
                          _back();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButtonForm(
                          bloc: bloc.formValidStream,
                          text: "Actualizar",
                          color: Colors.green,
                          onPressed: () {
                            _submit(formKey, usuario);
                          }),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  //Regresar a la interfaz anterior.
  _back() {
    Navigator.of(context).pop();
  }

  //Método de para enviar los datos del formulario a la base de datos.
  _submit(GlobalKey<FormState> formKey, UsuarioModel usu) async {
    if (!formKey.currentState!.validate()) return; //Validación del formulario.
    formKey.currentState?.save(); //Datos guardados en el formulario.
    usuario.idusuario = widget.idusuario;
    usuario.idrol = widget.idrol;

    await usuarioProvider.update(usu).then((value) {
      _alertDialog("Actualizado correctamente",
          "Debe volver a iniciar sesión para aplicar los cambios. ¿Cerrar sesión?");
    }).catchError((error) {
      print(error);
      _alertDialog("Error", "Error al actualizar la información.");
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
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Aceptar',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    Navigator.pushNamed(context, "principal");
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Método para mostrar las alertas.
  _alertDialog(String title, String content) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: title != "Error" ? Colors.black : Colors.red)),
        content: Text(content,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black)),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              title != "Error" ? "Más tarde" : "Aceptar",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: title != "Error" ? Colors.red : Colors.blue),
            ),
            onPressed: title != "Error"
                ? () {
                    _showSnackBar(
                        context, Colors.green, "Actualizado correctamente.");
                  }
                : () {
                    Navigator.of(context).pop("Discard");
                  },
          ),
          title != "Error"
              ? CupertinoDialogAction(
                  child: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    await prefs.remove('usuario');
                    Navigator.pushReplacementNamed(context, "login");
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
