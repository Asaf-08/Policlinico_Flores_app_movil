import 'package:policlinico_flores/models/conexion.dart';
import 'package:policlinico_flores/models/pagos_model.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase PagosProvider para el CRUD.
class PagosProvider {
  //Función asincrónica para la inserción de datos - CREAD.
  Future<void> insert(PagoModel pago) async {
    Database database = await Conexion.openDB();

    //Insertamos el registro
    await database.insert(
      "pagos",
      pago.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Función asincrónica para la actualización de datos - UPDATE.
  Future<void> update(PagoModel pago) async {
    Database database = await Conexion.openDB();

    //Se actualiza mediante el ID.
    await database.update(
      "pagos",
      pago.toMap(),
      where: "id_pago = ?",
      whereArgs: [pago.idpago],
    );
  }

  //Función asincrónica para la eliminación de datos - DELETE.
  Future<void> delete(PagoModel pago) async {
    Database database = await Conexion.openDB();

    //Se elimina mediante el ID.
    await database
        .delete("pagos", where: "id_pago = ?", whereArgs: [pago.idpago]);
  }

  //Función asincrónica para la consulta de datos - READ.
  Future<List<PagoModel>> pagos() async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> pagosMap =
        await database.query("pagos_view");

    //Leemos todos los campos.
    return List.generate(
      pagosMap.length,
      (i) => PagoModel(
          idpago: pagosMap[i]["id_pago"],
          idpaciente: pagosMap[i]["id_paciente"],
          idusuario: pagosMap[i]["id_usuario"],
          tipopago: pagosMap[i]["tipo_pago"],
          montototal: pagosMap[i]["monto_total"],
          fechapago: pagosMap[i]["fecha_pago"],
          paciente: pagosMap[i]["paciente"],
          dni: pagosMap[i]["dni"]),
    );
  }
}
