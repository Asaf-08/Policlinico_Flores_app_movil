import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/pacientes_model.dart';
import 'package:policlinico_flores/providers/pacientes_provider.dart';
import 'package:policlinico_flores/ui/bloc/pacientes_bloc.dart';
import 'package:policlinico_flores/ui/widgets/buttonfecha.dart';
import 'package:policlinico_flores/ui/widgets/buttonforms.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:policlinico_flores/ui/widgets/inputforms.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Creación de la clase con Widget de estado para los usuarios administradores.
class Pacientes extends StatefulWidget {
  //Definición de los atributos de la clase.
  final String title;
  final Color headerColor;
  final String btnText;
  final Color btnColor;
  const Pacientes(
      {Key? key,
      required this.title,
      required this.headerColor,
      required this.btnText,
      required this.btnColor})
      : super(key: key);

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  //Instancias de las clases e inicialización de objetos.
  final PacienteModel pacientes = PacienteModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final pacienteProvider = PacientesProvider();
  final bloc = PacientesBloc();
  int? _usuario;

  //Método de inicialización.
  @override
  void initState() {
    super.initState();
    _getUsuario();
  }

  //Método para obtener los datos almacenados en SharedPreferences.
  _getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuario = prefs.getInt('id_usuario');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            //Clase para el fondo de la interfaz con la asignación de los parámetros.
            FondoForms(
              nameUI: "Forms",
              colorfondo: widget.headerColor,
              colorclip1: Colors.white,
              colorclip2: const Color(0xFF333333),
              title: widget.title,
              subtitle: 'Complete la información.',
            ),
            _pacientesForm(context, pacientes, formKey),
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
  Widget _pacientesForm(BuildContext context, PacienteModel pacientes,
      GlobalKey<FormState> formKey) {
    //Instancia para obtener los argumentos que se pasen a la clase.
    final PacienteModel? pacData =
        ModalRoute.of(context)!.settings.arguments as PacienteModel?;

    //Comprobación si existen datos en los argumentos obtenidos.
    if (pacData != null) {
      pacientes = pacData;
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
                  value: pacientes.nombres,
                  lblText: "Nombres",
                  msgError: "Ingrese el nombre del paciente.",
                  onSaved: (value) => pacientes.nombres = value,
                  change: bloc.changeNombres,
                ),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.apellidosStream,
                  value: pacientes.apellidos,
                  lblText: "Apellidos",
                  msgError: "Ingrese los apellidos del paciente.",
                  onSaved: (value) => pacientes.apellidos = value,
                  change: bloc.changeApellidos,
                ),
                const SizedBox(height: 15),
                _rbGenero(pacientes.genero),
                const SizedBox(height: 15),
                CustomInputForm(
                  bloc: bloc.dniStream,
                  value: pacientes.dni,
                  lblText: "DNI",
                  msgError: "Ingrese el DNI del paciente.",
                  onSaved: (value) => pacientes.dni = value,
                  change: bloc.changeDNI,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: CustomInputForm(
                        bloc: null,
                        value: pacientes.edad.toString(),
                        lblText: "Edad",
                        onSaved: (value) {
                          pacientes.edad =
                              value == "" ? null : int.parse(value!);
                        },
                        change: null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomInputForm(
                        bloc: bloc.phoneStream,
                        value: pacientes.telefono,
                        lblText: "Teléfono",
                        msgError: "Ingrese el teléfono.",
                        onSaved: (value) => pacientes.telefono = value,
                        change: bloc.changePhone,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                ButtonFecha(
                  title: "Fecha de registro:",
                  fecha: pacientes.fecharegistro,
                  onSaved: (value) => pacientes.fecharegistro = value,
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
                          text: widget.btnText,
                          color: widget.btnColor,
                          onPressed: () {
                            _submit(formKey, pacientes.idpaciente, pacientes);
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

  //Definición del método para el campo de Género mediante RadioListTitle.
  Widget _rbGenero(String? genero) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Género: "),
        FormField<String>(
          initialValue: genero ?? "Masculino",
          onSaved: (value) {
            setState(() {
              pacientes.genero = value;
            });
          },
          builder: (FormFieldState state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: _myRadioButton(
                          title: "Masculino",
                          value: "Masculino",
                          groupValue: state.value,
                          onChanged: (value) {
                            setState(() {
                              state.didChange(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: _myRadioButton(
                          title: "Femenino",
                          value: "Femenino",
                          groupValue: state.value,
                          onChanged: (value) {
                            setState(() {
                              state.didChange(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            );
          },
        )
      ],
    );
  }

  Widget _myRadioButton(
      {String? title, String? value, String? groupValue, dynamic onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(title!),
    );
  }

  //Regresar a la interfaz anterior.
  _back() {
    Navigator.of(context).pop();
  }

  //Método de para enviar los datos del formulario a la base de datos.
  _submit(GlobalKey<FormState> formKey, int? idpaciente,
      PacienteModel paciente) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState?.save();
    pacientes.idusuario = _usuario;

    //Comprobamos si existe id del registro para insertar o en su defecto actualizar el registro.
    if (idpaciente == null) {
      await pacienteProvider.insert(pacientes).then((result) {
        if (result == "OK") {
          _showSnackBar(context, Colors.blue, "Guardado correctamente.");
        } else {
          _alertDialog("Error", result);
        }
      }).catchError((error) {
        print(error);
        _alertDialog("Error", "Error al registrar al paciente.");
      });
    } else {
      await pacienteProvider.update(paciente).then((value) {
        _showSnackBar(context, Colors.green, "Actualizado correctamente.");
      }).catchError((error) {
        print(error);
        _alertDialog("Error", "Error al actualizar al paciente.");
      });
    }

    print(await pacienteProvider.pacientes());
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
    Navigator.pushNamed(context, "listpacientes");
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
