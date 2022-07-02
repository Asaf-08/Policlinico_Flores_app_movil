import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/citas_model.dart';
import 'package:policlinico_flores/providers/citas_provider.dart';
import 'package:policlinico_flores/ui/pdf/reserva_cita.dart';
import 'package:policlinico_flores/ui/widgets/customclipper.dart';
import 'package:policlinico_flores/ui/widgets/inputsearch.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Creación de la clase con Widget de estado para los usuarios sin privilegios.
class ListaCitasUsuario extends StatefulWidget {
  const ListaCitasUsuario({Key? key}) : super(key: key);

  @override
  State<ListaCitasUsuario> createState() => _ListaCitasUsuarioState();
}

//Instancias las clases e inicialización de objetos.
class _ListaCitasUsuarioState extends State<ListaCitasUsuario> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final citasProvider = CitasProvider();
  final generarPDF = CitasPDF();
  List<CitaModel> citas = [];
  List<CitaModel> filtrocitas = [];
  Future<List<CitaModel>>? _future;
  int? _usuario;

  //Método de inicialización.
  @override
  void initState() {
    _getUsuario();
    super.initState();
  }

  //Método para obtener los datos almacenados en SharedPreferences.
  _getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuario = prefs.getInt('id_usuario');
    });
    _future = cargarCitas();
  }

  //Método para cargar los registros de la base de datos.
  Future<List<CitaModel>> cargarCitas() async {
    final List<CitaModel> auxCitas = await citasProvider.citasUser(_usuario);
    citas = auxCitas;
    filtrocitas = citas;
    return filtrocitas;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //Widget para controlar la acción del botón atras.
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        Navigator.pushReplacementNamed(context, "principal");
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(245, 255, 255, 255),
        extendBodyBehindAppBar: true,
        //Personalización del AppBar.
        appBar: AppBar(
          leading: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color.fromARGB(255, 0, 23, 60),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "principal");
                },
              ),
            )
          ]),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: size.height * 0.265),
                //Llamamos al método de listado de los registros.
                child: _listado()),
            Column(
              children: <Widget>[
                Container(
                  //Establecemos la altura del container mediante la altura del dispositivo.
                  height: size.height * 0.265,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromARGB(48, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0, -1),
                          spreadRadius: 0.1),
                    ],
                  ),
                  //Encabezado de la interfaz de la lista.
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                        title: Text("Citas",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 23, 60),
                                fontSize: 25,
                                fontWeight: FontWeight.w400)),
                        subtitle: Text(
                          "Lista de sus citas médicas.",
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 23, 60)),
                        ),
                      ),
                      InputSearch(
                        txtLabel: "Buscar cita",
                        change: (value) => _buscarCita(value),
                        search: _buscarCita,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Clase para la decoración de fondo.
            ClipperCustom(
                context: context,
                nameUI: "List",
                color1: const Color.fromARGB(255, 0, 108, 223),
                color2: const Color.fromARGB(255, 0, 108, 223))
          ],
        ),
        floatingActionButton: _btnNuevo(context),
      ),
    );
  }

  _buscarCita(String query) {
    final results = citas.where((cit) {
      final String data =
          "${cit.apellidos} ${cit.nombres} ${cit.fechacita} ${cit.horariocita}";
      final datos = data.toLowerCase();
      final input = query.toLowerCase();

      return datos.contains(input);
    }).toList();

    setState(() => filtrocitas = results);
  }

  //Método para listar los registros.
  _listado() {
    return FutureBuilder<List<CitaModel>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<CitaModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filtrocitas.length,
              itemBuilder: (context, i) => _item(context, i));
        } else {
          return const Center(
            child: LinearProgressIndicator(),
          );
        }
      },
    );
  }

  //Método con un Widget personalizado de los items de la lista.
  _item(BuildContext context, int i) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        //Cuadro de dialogo para la prevención de la eliminación del registro.
        return await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Eliminar cita",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black)),
              content: const Text("¿Está seguro?",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16)),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  //Acción asincrónica para eliminar correctamente el registro.
                  onPressed: () async {
                    await citasProvider
                        .delete(filtrocitas[i])
                        .then((value) => {Navigator.of(context).pop(true)})
                        .catchError((error) {
                      Navigator.of(context).pop(false);
                      _alertDialog("Error", "Error al eliminar la cita.");
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          },
        );
      },
      //Personalización del contenido del item.
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
        child: Card(
          color: citas[i].estado != 1
              ? const Color.fromARGB(255, 240, 240, 240)
              : Colors.white,
          elevation: 5,
          shadowColor: const Color.fromARGB(84, 0, 0, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: ListTile(
                    leading: const Icon(
                      Icons.date_range,
                      size: 40,
                      color: Colors.blue,
                    ),
                    title: Text(
                        "${filtrocitas[i].apellidos}, ${filtrocitas[i].nombres}"),
                    subtitle: Text(
                      'Fecha: ${filtrocitas[i].fechacita} | Horario: ${filtrocitas[i].horariocita}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                //Colores de etiqueta en base al estado de la cita.
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: citas[i].estado == 1
                              ? Colors.orange
                              : citas[i].estado == 2
                                  ? Colors.green
                                  : Colors.red),
                      child: PopupMenuButton(
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => [
                          _buildPopupMenuItem(
                              true, 2, 'Detalles', Icons.list_alt),
                        ],
                        child: const SizedBox(
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        //Acción asincrónica para generar el PDF con los detalles de la cita.
                        onSelected: (value) async {
                          final data = await generarPDF.reservacita(citas[i]);
                          generarPDF.savePDF(
                              "reserva_cita_${citas[i].idcita}", data);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Método para la creación del botón nuevo.
  _btnNuevo(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: const Color.fromARGB(255, 0, 108, 223),
      elevation: 10,
      onPressed: () => Navigator.pushNamed(context, "newcita"),
    );
  }

  //Método para la creación de los items del PopupMenu.
  PopupMenuItem _buildPopupMenuItem(
      bool enabled, int value, String title, IconData iconData) {
    return PopupMenuItem(
      enabled: enabled,
      value: value,
      child: Row(
        children: [
          Icon(
            iconData,
          ),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }

  //Cuadro de dialogo para mostrar las alertas.
  _alertDialog(String title, String content) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.red)),
        content: Text(content,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black)),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text(
              "Aceptar",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.blue),
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
