import 'package:policlinico_flores/models/conexion.dart';
import 'package:policlinico_flores/models/usuarios_model.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase UsuariosProvider para el CRUD.
class UsuariosProvider {
  //Función asincrónica para la inserción de datos - CREAD.
  Future<String> insert(UsuarioModel usuario) async {
    Database database = await Conexion.openDB();

    //Obtenemos las consultas con las condiciones requeridas.
    final countusuario = await database.query(
      "usuarios",
      where: "usuario = ?",
      whereArgs: [usuario.usuario],
    );

    final countemail = await database.query(
      "usuarios",
      where: "email = ?",
      whereArgs: [usuario.email],
    );

    //Insertamos el registro si no hay ninguna fila de las consultas anteriores.
    if (countusuario.isNotEmpty && countemail.isNotEmpty) {
      return "El usuario y el email ingresados ya existen.";
    } else if (countusuario.isNotEmpty) {
      return "El usuario ingresado ya existe.";
    } else if (countemail.isNotEmpty) {
      return "El email ingresado ya existe.";
    } else {
      await database.insert(
        "usuarios",
        usuario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return "OK";
    }
  }

  //Función asincrónica para la actualización de datos - UPDATE.
  Future<void> update(UsuarioModel usuario) async {
    Database database = await Conexion.openDB();

    //Se actualiza mediante el ID.
    await database.update(
      "usuarios",
      usuario.toMap(),
      where: "id_usuario = ?",
      whereArgs: [usuario.idusuario],
    );
  }

  //Función asincrónica para la eliminación de datos - DELETE.
  Future<void> delete(UsuarioModel usuario) async {
    Database database = await Conexion.openDB();

    //Se elimina mediante el ID.
    await database.delete("usuarios",
        where: "id_usuario = ?", whereArgs: [usuario.idusuario]);
  }

  //Función asincrónica para la consulta de datos - READ.
  Future<List<UsuarioModel>> usuarios() async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> usuariosMap =
        await database.query("usuarios");

    //Leemos todos los campos.
    return List.generate(
      usuariosMap.length,
      (i) => UsuarioModel(
          idusuario: usuariosMap[i]["id_usuario"],
          idrol: usuariosMap[i]["id_rol"],
          nombres: usuariosMap[i]["nombres"],
          apellidos: usuariosMap[i]["apellidos"],
          email: usuariosMap[i]["email"],
          usuario: usuariosMap[i]["usuario"],
          password: usuariosMap[i]["password"]),
    );
  }

  //Función asincrónica para la consulta de datos por ID- READ.
  Future<List<UsuarioModel>> usuariosId(int? idusuario) async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> usuariosMap = await database
        .query("usuarios", where: "id_usuario = ?", whereArgs: [idusuario]);

    //Leemos todos los campos.
    return List.generate(
      usuariosMap.length,
      (i) => UsuarioModel(
          idusuario: usuariosMap[i]["id_usuario"],
          idrol: usuariosMap[i]["id_rol"],
          nombres: usuariosMap[i]["nombres"],
          apellidos: usuariosMap[i]["apellidos"],
          email: usuariosMap[i]["email"],
          usuario: usuariosMap[i]["usuario"],
          password: usuariosMap[i]["password"]),
    );
  }

  //Función asincrónica para la consulta de inicio de sesión.
  Future<UsuarioModel?> login(UsuarioModel usuario) async {
    Database database = await Conexion.openDB();

    final count = await database.query(
      "usuarios",
      where: "usuario = ? and password = ?",
      whereArgs: [usuario.usuario, usuario.password],
    );

    //Comprobamos que existe el usuario que ingresamos.
    if (count.isNotEmpty) {
      return UsuarioModel.fromMap(count.first);
    }

    return null;
  }
}
