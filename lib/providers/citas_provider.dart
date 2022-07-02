import 'package:policlinico_flores/models/citas_model.dart';
import 'package:policlinico_flores/models/conexion.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase CitasProvider para el CRUD.
class CitasProvider {
  //Función asincrónica para la inserción de datos - CREAD.
  Future<String> insert(CitaModel cita) async {
    Database database = await Conexion.openDB();

    //Obtenemos la consulta con la condición requerida.
    final count = await database.query(
      "citas",
      where: "id_usuario = ? and fecha_cita = ?",
      whereArgs: [cita.idusuario, cita.fechacita],
    );

    //Insertamos el registro si no hay ninguna fila de la consulta anterior.
    if (count.isNotEmpty) {
      return "Ya tiene una cita registrada en la fecha establecida.";
    } else {
      await database.insert(
        "citas",
        cita.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return "OK";
    }
  }

  //Función asincrónica para la actualización de datos - UPDATE.
  Future<void> update(CitaModel cita) async {
    Database database = await Conexion.openDB();

    //Se actualiza mediante el ID.
    await database.update(
      "citas",
      cita.toMap(),
      where: "id_cita = ?",
      whereArgs: [cita.idcita],
    );
  }

  //Función asincrónica para la actualización del estado.
  Future<void> updateEstado(CitaModel cita) async {
    Database database = await Conexion.openDB();

    //Se elimina mediante el ID.
    await database.rawUpdate(
        "Update citas set estado = ${cita.estado} Where = ${cita.idcita}");
  }

  //Función asincrónica para la eliminación de datos - DELETE.
  Future<void> delete(CitaModel cita) async {
    Database database = await Conexion.openDB();

    await database
        .delete("citas", where: "id_cita = ?", whereArgs: [cita.idcita]);
  }

  //Función asincrónica para la consulta de datos - READ.
  Future<List<CitaModel>> citas() async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> citasMap =
        await database.query("citas_view");

    return List.generate(
      citasMap.length,
      (i) => CitaModel(
          idcita: citasMap[i]["id_cita"],
          idusuario: citasMap[i]["id_usuario"],
          area: citasMap[i]["area_atencion"],
          fechacita: citasMap[i]["fecha_cita"],
          horariocita: citasMap[i]["horario_cita"],
          nombres: citasMap[i]["nombres"],
          apellidos: citasMap[i]["apellidos"],
          estado: citasMap[i]["estado"]),
    );
  }

  Future<int?> citasPendientes() async {
    Database database = await Conexion.openDB();

    final int? count = Sqflite.firstIntValue(
        await database.rawQuery("Select Count(*) From citas Where estado = 1"));
    return count;
  }

  //Leemos todos los campos por medio del ID.
  Future<List<CitaModel>> citasUser(int? idusuario) async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> citasUserMap = await database
        .query("citas_view", where: "id_usuario = ?", whereArgs: [idusuario]);

    return List.generate(
      citasUserMap.length,
      (i) => CitaModel(
          idcita: citasUserMap[i]["id_cita"],
          idusuario: citasUserMap[i]["id_usuario"],
          area: citasUserMap[i]["area_atencion"],
          fechacita: citasUserMap[i]["fecha_cita"],
          horariocita: citasUserMap[i]["horario_cita"],
          nombres: citasUserMap[i]["nombres"],
          apellidos: citasUserMap[i]["apellidos"],
          estado: citasUserMap[i]["estado"]),
    );
  }
}
