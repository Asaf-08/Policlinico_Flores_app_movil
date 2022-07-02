import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/consulta_model.dart';
import 'package:policlinico_flores/providers/consultas_provider.dart';
import 'package:policlinico_flores/providers/pacientes_provider.dart';
import 'package:policlinico_flores/ui/bloc/consultas_bloc.dart';
import 'package:policlinico_flores/ui/widgets/buttonfecha.dart';
import 'package:policlinico_flores/ui/widgets/buttonforms.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:policlinico_flores/ui/widgets/dropbutton.dart';
import 'package:policlinico_flores/ui/widgets/inputforms.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Creación de la clase con Widget de estado para los usuarios administradores.
class Consultas extends StatefulWidget {
  //Definición de los atributos de la clase.
  final String title;
  final Color headerColor;
  final String btnText;
  final Color btnColor;
  const Consultas(
      {Key? key,
      required this.title,
      required this.headerColor,
      required this.btnText,
      required this.btnColor})
      : super(key: key);

  @override
  State<Consultas> createState() => _ConsultasState();
}

class _ConsultasState extends State<Consultas> {
  //Instancias de las clases e inicialización de objetos.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ConsultaModel consultas = ConsultaModel();
  final consultaProvider = ConsultasProvider();
  final pacienteProvider = PacientesProvider();
  final bloc = ConsultasBloc();
  final List<DropdownMenuItem<dynamic>> _pacienteslist = [];
  int? _selectedvalue;
  int? _usuario;

  //Método de inicialización.
  @override
  void initState() {
    super.initState();
    _cargarPacientes();
    _getUsuario();
  }

  //Método para obtener el registro pacientes.
  _cargarPacientes() async {
    final pacientes = await pacienteProvider.pacientes();
    for (var paciente in pacientes) {
      _selectedvalue = pacientes[0].idpaciente;
      setState(() {
        _pacienteslist.add(DropdownMenuItem<dynamic>(
          child: Text("${paciente.apellidos}, ${paciente.nombres}"),
          value: paciente.idpaciente,
        ));
      });
    }
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
            _consultasForm(context, consultas, formKey),
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
  Widget _consultasForm(BuildContext context, ConsultaModel consultas,
      GlobalKey<FormState> formKey) {
    //Instancia para obtener los argumentos que se pasen a la clase.
    final ConsultaModel? conData =
        ModalRoute.of(context)!.settings.arguments as ConsultaModel?;

    //Comprobación si existen datos en los argumentos obtenidos.
    if (conData != null) {
      consultas = conData;
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
                const SizedBox(height: 10),
                CustomDropdownButton(
                  title: "Seleccionar paciente",
                  selectedvalue: _selectedvalue,
                  lista: _pacienteslist,
                  value: consultas.idpaciente,
                  onSaved: (value) => consultas.idpaciente = int.parse(value!),
                  validator: (value) {
                    if (_selectedvalue == null) {
                      return "Seleccione un paciente";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomInputForm(
                  bloc: bloc.motivoStream,
                  value: consultas.motivo,
                  lblText: "Motivo de consulta",
                  msgError: "Ingrese el motivo de la consulta.",
                  onSaved: (value) => consultas.motivo = value,
                  change: bloc.changeMotivo,
                ),
                const SizedBox(height: 20),
                CustomDropdownButton(
                  title: "Seleccionar área de atención",
                  selectedvalue: "Medicina general",
                  lista: <String>[
                    "Medicina general",
                    "Oftalmología",
                    "Pediatría",
                    "Obstetricia",
                  ]
                      .map(
                        (value) => DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        ),
                      )
                      .toList(),
                  value: consultas.area,
                  onSaved: (value) => consultas.area = value,
                ),
                const SizedBox(height: 15),
                ButtonFecha(
                  title: "Fecha de consulta:",
                  fecha: consultas.fechaconsulta,
                  onSaved: (value) => consultas.fechaconsulta = value,
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
                          bloc: bloc.motivoStream,
                          text: widget.btnText,
                          color: widget.btnColor,
                          onPressed: () {
                            _submit(formKey, consultas.idconsulta, consultas);
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
  _submit(GlobalKey<FormState> formKey, int? idconsulta,
      ConsultaModel consulta) async {
    if (!formKey.currentState!.validate()) return; //Validación del formulario.
    formKey.currentState?.save(); //Datos guardados en el formulario.
    consultas.idusuario = _usuario;

    //Comprobamos si existe id del registro para insertar o en su defecto actualizar el registro.
    if (idconsulta == null) {
      await consultaProvider.insert(consultas).then((value) {
        _showSnackBar(context, Colors.blue, "Guardado correctamente.");
      }).catchError((error) {
        print(error);
        _alertDialog("Error", "Error al registrar la consulta.");
      });
    } else {
      await consultaProvider.update(consulta).then((value) {
        _showSnackBar(context, Colors.green, "Actualizado correctamente.");
      }).catchError((error) {
        print(error);
        _alertDialog("Error", "Error al actualizar la consulta.");
      });
    }

    print(await consultaProvider.consultas());
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
    Navigator.pushNamed(context, "listconsultas");
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
