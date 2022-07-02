import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/citas_model.dart';
import 'package:policlinico_flores/providers/citas_provider.dart';
import 'package:policlinico_flores/ui/widgets/buttonfecha.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:policlinico_flores/ui/widgets/dropbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Creación de la clase con Widget de estado para los usuarios sin privilegios.
class Citas extends StatefulWidget {
  //Definición de los atributos de la clase.
  final String title;
  final Color headerColor;
  final String btnText;
  final Color btnColor;
  const Citas(
      {Key? key,
      required this.title,
      required this.headerColor,
      required this.btnText,
      required this.btnColor})
      : super(key: key);

  @override
  State<Citas> createState() => _CitasState();
}

class _CitasState extends State<Citas> {
  //Instancias las clases e inicialización de objetos.
  final CitaModel citas = CitaModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final citaProvider = CitasProvider();
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
            _citasForm(context, citas, formKey),
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
  Widget _citasForm(
      BuildContext context, CitaModel citas, GlobalKey<FormState> formKey) {
    //Instancia para obtener los argumentos que se pasen a la clase.
    final CitaModel? citaData =
        ModalRoute.of(context)!.settings.arguments as CitaModel?;

    //Comprobación si existen datos en los argumentos obtenidos.
    if (citaData != null) {
      citas = citaData;
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
                    blurRadius: 10,
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
                  value: citas.area,
                  onSaved: (value) => citas.area = value,
                ),
                const SizedBox(height: 15),
                ButtonFecha(
                  title: "Fecha de cita",
                  fecha: citas.fechacita,
                  onSaved: (value) => citas.fechacita = value,
                ),
                const SizedBox(height: 15),
                CustomDropdownButton(
                  title: "Seleccionar horario de cita",
                  selectedvalue: "Mañana",
                  lista: <String>["Mañana", "Tarde", "Noche"]
                      .map(
                        (value) => DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        ),
                      )
                      .toList(),
                  value: citas.horariocita,
                  onSaved: (value) => citas.horariocita = value,
                ),
                const SizedBox(height: 30),
                _btnGuardar(citas.idcita, citas),
                const SizedBox(height: 10),
                _btnCancelar(),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  //Método para la creación de botón de cancelar.
  Widget _btnCancelar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 15),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF515151)),
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
                onPressed: () {
                  //Regresamos a la interaz anterior.
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  //Método para la creación del botón de guardar
  Widget _btnGuardar(int? idcita, CitaModel citas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text(
                  widget.btnText,
                  style: const TextStyle(fontSize: 15),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(45)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    widget.btnColor,
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
                onPressed: () {
                  _submit(formKey, idcita, citas);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  //Método para guardar o actualizar el registro mediante la llave del formulario.
  _submit(GlobalKey<FormState> formKey, int? idcita, CitaModel cita) async {
    if (!formKey.currentState!.validate()) return; //Validación del formulario.
    formKey.currentState?.save(); //Datos guardados en el formulario.

    citas.idusuario = _usuario;

    //Comprobamos si existe id del registro para insertar o en su defecto actualizar el registro.
    if (idcita == null) {
      await citaProvider.insert(citas).then((result) {
        if (result == "OK") {
          _showSnackBar(context, Colors.blue, "Guardado correctamente.");
        } else {
          _alertDialog("Error", result);
        }
      }).catchError((error) {
        print(error);
        _alertDialog("Error", "Error al registrar la cita.");
      });
    } else {
      await citaProvider.update(cita).then((value) {
        _showSnackBar(context, Colors.green, "Actualizado correctamente.");
      }).catchError((error) {
        print(error);
        _alertDialog("Error", "Error al actualizar la cita.");
      });
    }

    print(await citaProvider.citas());
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
    Navigator.pushNamed(context, "listcitasuser");
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
