import 'package:policlinico_flores/models/conexion.dart';
import 'package:policlinico_flores/models/pacientes_model.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase PacientesProvider para el CRUD.
class PacientesProvider {
  //Función asincrónica para la inserción de datos - CREAD.
  Future<String> insert(PacienteModel paciente) async {
    Database database = await Conexion.openDB();

    //Obtenemos las consultas con las condiciones requeridas.
    final countdni = await database.query(
      "pacientes",
      where: "dni = ?",
      whereArgs: [paciente.dni],
    );

    final countphone = await database.query(
      "pacientes",
      where: "telefono = ?",
      whereArgs: [paciente.telefono],
    );

    //Insertamos el registro si no hay ninguna fila de las consultas anteriores.
    if (countdni.isNotEmpty && countphone.isNotEmpty) {
      return "El DNI y el teléfono ingresados ya existen.";
    } else if (countdni.isNotEmpty) {
      return "El DNI ingresado ya existe.";
    } else if (countphone.isNotEmpty) {
      return "El teléfono ingresado ya existe.";
    } else {
      await database.insert(
        "pacientes",
        paciente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return "OK";
    }
  }

  //Función asincrónica para la actualización de datos - UPDATE.
  Future<void> update(PacienteModel paciente) async {
    Database database = await Conexion.openDB();

    //Se actualiza mediante el ID.
    await database.update(
      "pacientes",
      paciente.toMap(),
      where: "id_paciente = ?",
      whereArgs: [paciente.idpaciente],
    );
  }

  //Función asincrónica para la eliminación de datos - DELETE.
  Future<String> delete(PacienteModel paciente) async {
    Database database = await Conexion.openDB();

    //Obtenemos las consultas con las condiciones requeridas.
    final inconsultas = await database.query(
      "consultas",
      where: "id_paciente = ?",
      whereArgs: [paciente.idpaciente],
    );

    final inpagos = await database.query(
      "pagos",
      where: "id_paciente = ?",
      whereArgs: [paciente.idpaciente],
    );

    //Validamos que no existan datos en las consultas anteriores para eliminar la el registro.
    if (inconsultas.isNotEmpty && inpagos.isNotEmpty) {
      return "No se puede eliminar al paciente porque aún tiene información en los registros de consultas y pagos.";
    } else if (inconsultas.isNotEmpty) {
      return "No se puede eliminar al paciente porque aún tiene información en el registro de consultas.";
    } else if (inpagos.isNotEmpty) {
      return "No se puede eliminar al paciente porque aún tiene información en el registro de pagos.";
    } else {
      await database.delete("pacientes",
          where: "id_paciente = ?", whereArgs: [paciente.idpaciente]);
      return "OK";
    }
  }

  //Función asincrónica para la consulta de datos - READ.
  Future<List<PacienteModel>> pacientes() async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> pacientesMap =
        await database.query("pacientes");

    //Leemos todos los campos.
    return List.generate(
      pacientesMap.length,
      (i) => PacienteModel(
          idpaciente: pacientesMap[i]["id_paciente"],
          idusuario: pacientesMap[i]["id_usuario"],
          nombres: pacientesMap[i]["nombres"],
          apellidos: pacientesMap[i]["apellidos"],
          dni: pacientesMap[i]["dni"],
          edad: pacientesMap[i]["edad"],
          genero: pacientesMap[i]["genero"],
          telefono: pacientesMap[i]["telefono"],
          fecharegistro: pacientesMap[i]["fecha_registro"]),
    );
  }
}
