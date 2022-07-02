import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/pagos_model.dart';
import 'package:policlinico_flores/providers/pagos_provider.dart';
import 'package:policlinico_flores/ui/widgets/customclipper.dart';
import 'package:policlinico_flores/ui/widgets/inputsearch.dart';

//Creación de la clase con Widget de estado para los usuarios administradores.
class ListaPagos extends StatefulWidget {
  const ListaPagos({Key? key}) : super(key: key);

  @override
  State<ListaPagos> createState() => _ListaPagosState();
}

//Instancias las clases e inicialización de objetos.
class _ListaPagosState extends State<ListaPagos> {
  final pagosProvider = PagosProvider();
  List<PagoModel> pagos = [];
  List<PagoModel> filtropagos = [];
  Future<List<PagoModel>>? _future;

  //Método de inicialización.
  @override
  void initState() {
    _future = cargarPagos();
    super.initState();
  }

  //Método para cargar los registros de la base de datos.
  Future<List<PagoModel>> cargarPagos() async {
    final List<PagoModel> auxPago = await pagosProvider.pagos();
    pagos = auxPago;
    filtropagos = pagos;
    return filtropagos;
  }

  //Widget para controlar la acción del botón atras.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

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
        body: SafeArea(
          top: false,
          bottom: false,
          minimum: EdgeInsets.only(top: padding.top),
          child: Stack(
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 35),
                          title: Text("Pagos",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 23, 60),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400)),
                          subtitle: Text(
                            "Lista de pagos.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 23, 60)),
                          ),
                        ),
                        InputSearch(
                          txtLabel: "Buscar pago",
                          change: (value) => _buscarPago(value),
                          search: _buscarPago,
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
        ),
        floatingActionButton: _btnNuevo(context),
      ),
    );
  }

  _buscarPago(String query) {
    final results = pagos.where((pag) {
      final String data = "${pag.paciente} ${pag.fechapago} ${pag.montototal}";
      final datos = data.toLowerCase();
      final input = query.toLowerCase();

      return datos.contains(input);
    }).toList();

    setState(() => filtropagos = results);
  }

  //Método para listar los registros.
  _listado() {
    return FutureBuilder<List<PagoModel>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<PagoModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filtropagos.length,
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
              title: const Text("Eliminar pago",
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
                    await pagosProvider
                        .delete(filtropagos[i])
                        .then((value) => {Navigator.of(context).pop(true)})
                        .catchError((error) {
                      Navigator.of(context).pop(false);
                      _alertDialog("Error", "Error al eliminar el pago.");
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
          elevation: 5,
          shadowColor: const Color.fromARGB(84, 0, 0, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.payment,
              size: 40,
              color: Colors.blue,
            ),
            title: Text('${filtropagos[i].paciente}'),
            subtitle: Text(
                'Fecha: ${filtropagos[i].fechapago} | Monto: S/${filtropagos[i].montototal}'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.pushNamed(context, 'editpago',
                arguments: filtropagos[i]),
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
      onPressed: () {
        Navigator.pushNamed(context, "newpago");
      },
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
