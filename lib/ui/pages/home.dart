import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:policlinico_flores/providers/citas_provider.dart';
import 'package:policlinico_flores/ui/pages/usuarios.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdmin extends KFDrawerContent {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final citasProvider = CitasProvider();

  String? _nombres;
  String? _apellidos;
  int? _countcitas;

  @override
  void initState() {
    _getDataUsuario();
    _getCountCitas();
    super.initState();
  }

  _getDataUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombres = prefs.getString('nombres');
      _apellidos = prefs.getString('apellidos');
    });
  }

  _getCountCitas() async {
    _countcitas = await citasProvider.citasPendientes();
    setState(() {
      _countcitas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FondoForms(
            nameUI: "Menu",
            colorfondo: const Color.fromARGB(255, 0, 108, 223),
            colorclip1: Colors.white,
            colorclip2: const Color(0xFF333333),
            title: "Policlínico Flores",
            subtitle: "Bienvenido(a) $_apellidos, $_nombres",
          ),
          SafeArea(
            child: Center(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                clipBehavior: Clip.none,
                children: <Widget>[
                  SizedBox(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        child: Material(
                          shadowColor: Colors.transparent,
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: widget.onMenuPressed,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: ResponsiveGridRow(
                      children: [
                        ResponsiveGridCol(
                          lg: 12,
                          child: Container(
                            height: (size.height * 0.25),
                            alignment: const Alignment(0, 0),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _countcitas != null && _countcitas != 0
                                ? Badge(
                                    badgeContent: Text(
                                      "$_countcitas",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    animationType: BadgeAnimationType.slide,
                                    badgeColor: Colors.red,
                                    elevation: 0,
                                    child: CategoryCard(
                                      title: "Citas",
                                      imgSrc: "assets/images/cardcitas.png",
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "listcitas");
                                      },
                                    ),
                                  )
                                : CategoryCard(
                                    title: "Citas",
                                    imgSrc: "assets/images/cardcitas.png",
                                    onTap: () {
                                      Navigator.pushNamed(context, "listcitas");
                                    },
                                  ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 6,
                          md: 3,
                          child: Container(
                            height: (size.height * 0.25),
                            alignment: const Alignment(0, 0),
                            padding:
                                const EdgeInsets.only(bottom: 10, right: 5),
                            child: CategoryCard(
                              title: "Pacientes",
                              imgSrc: "assets/images/cardpacientes.png",
                              onTap: () {
                                Navigator.pushNamed(context, "listpacientes");
                              },
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 6,
                          md: 3,
                          child: Container(
                            height: (size.height * 0.25),
                            alignment: const Alignment(0, 0),
                            padding: const EdgeInsets.only(bottom: 10, left: 5),
                            child: CategoryCard(
                              title: "Consultas",
                              imgSrc: "assets/images/cardconsultas.png",
                              onTap: () {
                                Navigator.pushNamed(context, "listconsultas");
                              },
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 6,
                          md: 3,
                          child: Container(
                            height: (size.height * 0.25),
                            alignment: const Alignment(0, 0),
                            padding:
                                const EdgeInsets.only(bottom: 10, right: 5),
                            child: CategoryCard(
                              title: "Pagos",
                              imgSrc: "assets/images/cardpagos.png",
                              onTap: () {
                                Navigator.pushNamed(context, "listpagos");
                              },
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 6,
                          md: 3,
                          child: Container(
                            height: (size.height * 0.25),
                            alignment: const Alignment(0, 0),
                            padding: const EdgeInsets.only(bottom: 10, left: 5),
                            child: CategoryCard(
                              title: "Fichas Clínicas",
                              imgSrc: "assets/images/cardfichas.png",
                              onTap: () {
                                Navigator.pushNamed(context, "listfichas");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeUser extends KFDrawerContent {
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  int? _idusuario;
  int? _idrol;
  String? _nombres;
  String? _apellidos;
  String? _email;
  String? _usuario;
  String? _password;

  @override
  void initState() {
    _getUsuario();
    super.initState();
  }

  _getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idusuario = prefs.getInt('id_usuario');
      _idrol = prefs.getInt('id_rol');
      _nombres = prefs.getString('nombres');
      _apellidos = prefs.getString('apellidos');
      _email = prefs.getString('email');
      _usuario = prefs.getString('usuario');
      _password = prefs.getString('password');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FondoForms(
            nameUI: "Menu",
            colorfondo: const Color.fromARGB(255, 0, 108, 223),
            colorclip1: Colors.white,
            colorclip2: const Color(0xFF333333),
            title: "Policlínico Flores",
            subtitle: "Bienvenido(a) $_apellidos, $_nombres",
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        child: Material(
                          shadowColor: Colors.transparent,
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: widget.onMenuPressed,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: size.height,
                      padding:
                          const EdgeInsets.only(top: 70, left: 20, right: 20),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: <Widget>[
                          StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 3 / 2.5,
                              child: CategoryCard(
                                  rol: "user",
                                  title: "Citas",
                                  imgSrc: "assets/images/cardcitas.png",
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "listcitasuser");
                                  })),
                          StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 3 / 2.5,
                              child: CategoryCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Usuarios(
                                          idusuario: _idusuario,
                                          idrol: _idrol,
                                          nombres: _nombres,
                                          apellidos: _apellidos,
                                          email: _email,
                                          usuario: _usuario,
                                          password: _password,
                                        ),
                                      ),
                                    );
                                  },
                                  rol: "user",
                                  title: "Mi perfil",
                                  imgSrc: "assets/images/miperfil.png")),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String? rol;
  final String imgSrc;
  final String title;
  final Function()? onTap;
  const CategoryCard({
    Key? key,
    this.rol,
    required this.imgSrc,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(3),
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ]),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image.asset(
              imgSrc,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          left: 2,
          right: 2,
          bottom: 2,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: const Color.fromARGB(27, 255, 255, 255),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(204, 0, 0, 0),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(13),
                      bottomRight: Radius.circular(13)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: rol == "user" ? 170 : 115,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rol == "user" ? 22 : 18,
                          fontWeight:
                              rol == "user" ? FontWeight.w400 : FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
