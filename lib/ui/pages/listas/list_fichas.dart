import 'package:flutter/material.dart';
import 'package:policlinico_flores/models/fichas_model.dart';
import 'package:policlinico_flores/providers/fichas_provider.dart';
import 'package:policlinico_flores/ui/pdf/ficha_clinica.dart';
import 'package:policlinico_flores/ui/widgets/customclipper.dart';
import 'package:policlinico_flores/ui/widgets/inputsearch.dart';

//Creación de la clase con Widget de estado para los usuarios administradores.
class ListaFichas extends StatefulWidget {
  const ListaFichas({Key? key}) : super(key: key);

  @override
  State<ListaFichas> createState() => _ListaFichasState();
}

//Instancias las clases e inicialización de objetos.
class _ListaFichasState extends State<ListaFichas> {
  final fichasProvider = FichasProvider();
  final generarPDF = FichasPDF();
  List<FichaModel> fichas = [];
  List<FichaModel> filtrofichas = [];
  Future<List<FichaModel>>? _future;

  //Método de inicialización.
  @override
  void initState() {
    _future = cargarFichas();
    super.initState();
  }

  //Método para cargar los registros de la base de datos.
  Future<List<FichaModel>> cargarFichas() async {
    final List<FichaModel> auxFicha = await fichasProvider.fichas();
    fichas = auxFicha;
    filtrofichas = fichas;
    return filtrofichas;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

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
                    //Establecemos la altura del container mediante la altura del dispositivo.height: size.height * 0.265,
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
                          title: Text("Fichas clínicas",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 23, 60),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400)),
                          subtitle: Text(
                            "Búsqueda de fichas clínicas.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 23, 60)),
                          ),
                        ),
                        InputSearch(
                          txtLabel: "Buscar ficha clínica",
                          change: (value) => _buscarFicha(value),
                          search: _buscarFicha,
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
      ),
    );
  }

  _buscarFicha(String query) {
    final results = fichas.where((fic) {
      final String data =
          "${fic.apellidos} ${fic.nombres} ${fic.dni} ${fic.area}";
      final datos = data.toLowerCase();
      final input = query.toLowerCase();

      return datos.contains(input);
    }).toList();

    setState(() => filtrofichas = results);
  }

  //Método para listar los registros.
  _listado() {
    return FutureBuilder<List<FichaModel>>(
      future: _future,
      builder:
          (BuildContext context, AsyncSnapshot<List<FichaModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filtrofichas.length,
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
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      child: Card(
        elevation: 5,
        shadowColor: const Color.fromARGB(84, 0, 0, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
            leading: const Icon(
              Icons.picture_as_pdf_outlined,
              size: 40,
              color: Colors.red,
            ),
            title: Text(
                '${filtrofichas[i].apellidos}, ${filtrofichas[i].nombres}'),
            subtitle:
                Text('DNI: ${filtrofichas[i].dni} | ${filtrofichas[i].area}'),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
            ),
            //Acción asincrónica para generar el PDF con los detalles de la ficha clínica.
            onTap: () async {
              final data = await generarPDF.fichaclinica(filtrofichas[i]);
              generarPDF.savePDF(
                  "ficha_clínica_${filtrofichas[i].codigoficha}", data);
            }),
      ),
    );
  }
}
