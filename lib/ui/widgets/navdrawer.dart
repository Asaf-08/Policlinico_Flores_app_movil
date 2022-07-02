import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:policlinico_flores/ui/controller/classbuilder.dart';
import 'package:policlinico_flores/ui/pages/home.dart';
import 'package:policlinico_flores/ui/pages/usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with TickerProviderStateMixin {
  KFDrawerController? _drawerController;
  int? _idusuario;
  int? _idrol;
  String? _nombres;
  String? _apellidos;
  String? _usuario;
  String? _email;
  String? _password;

  _loadPage() async {
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
    _navigatorDrawer();
  }

  _navigatorDrawer() {
    _drawerController = KFDrawerController(
      initialPage:
          ClassBuilder.fromString(_idrol == 1 ? 'HomeAdmin' : 'HomeUser'),
      items: _idrol == 1
          ? <KFDrawerItem>[
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Inicio",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                page: HomeAdmin(),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Mi perfil",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.person_pin_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
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
                ),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Citas",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "listcitas"),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Pacientes",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "listpacientes"),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Consultas",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.paste,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "listconsultas"),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Pagos",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.payment,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "listpagos"),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Fichas",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.article_outlined,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "listfichas"),
              )
            ]
          : <KFDrawerItem>[
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Inicio",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.person_pin_rounded,
                  color: Colors.white,
                ),
                page: HomeAdmin(),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Mi perfil",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
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
                ),
              ),
              KFDrawerItem.initWithPage(
                text: const Text(
                  "Citas",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "listcitasuser"),
              ),
            ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: KFDrawer(
          controller: _drawerController,
          header: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/user.png"),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _usuario.toString(),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _email.toString(),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          footer: KFDrawerItem(
            text: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              _alertDialog("Cerrar sesión", "¿Está seguro?");
            },
          ),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }

  _alertDialog(String title, String content) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black)),
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
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await prefs.remove('usuario');
              Navigator.pushReplacementNamed(context, "login");
            },
          ),
          CupertinoDialogAction(
            child: const Text(
              "Cancelar",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.red),
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
