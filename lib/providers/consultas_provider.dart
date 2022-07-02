import 'package:policlinico_flores/models/conexion.dart';
import 'package:policlinico_flores/models/consulta_model.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase ConsultasProvider para el CRUD.
class ConsultasProvider {
  //Función asincrónica para la inserción de datos - CREAD.
  Future<void> insert(ConsultaModel consulta) async {
    Database database = await Conexion.openDB();

    //Obtenemos la consulta con la condición requerida.
    final idconsulta = await database.insert(
      "consultas",
      consulta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //Insertamos el registro obteniendo el último ID ingresado en la consulta anterior.
    await database
        .rawInsert("Insert Into fichas(id_consulta) Values ($idconsulta)");
  }

  //Función asincrónica para la actualización de datos - UPDATE.
  Future<void> update(ConsultaModel consulta) async {
    Database database = await Conexion.openDB();

    //Se actualiza mediante el ID.
    await database.update(
      "consultas",
      consulta.toMap(),
      where: "id_consulta = ?",
      whereArgs: [consulta.idconsulta],
    );
  }

  //Función asincrónica para la eliminación de datos - DELETE.
  Future<void> delete(ConsultaModel consulta) async {
    Database database = await Conexion.openDB();

    //Eliminamos las filas según el ID requerido.
    await database.delete("fichas",
        where: "id_consulta = ?", whereArgs: [consulta.idconsulta]);
    await database.delete("consultas",
        where: "id_consulta = ?", whereArgs: [consulta.idconsulta]);
  }

  //Función asincrónica para la consulta de datos - READ.
  Future<List<ConsultaModel>> consultas() async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> consultasMap =
        await database.query("consultas_view");

    //Leemos todos los campos.
    return List.generate(
      consultasMap.length,
      (i) => ConsultaModel(
          idconsulta: consultasMap[i]["id_consulta"],
          idpaciente: consultasMap[i]["id_paciente"],
          idusuario: consultasMap[i]["id_usuario"],
          area: consultasMap[i]["area_atencion"],
          motivo: consultasMap[i]["motivo"],
          fechaconsulta: consultasMap[i]["fecha_consulta"],
          paciente: consultasMap[i]["paciente"],
          dni: consultasMap[i]["dni"]),
    );
  }
}
