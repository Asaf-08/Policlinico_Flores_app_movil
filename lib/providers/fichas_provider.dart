import 'package:policlinico_flores/models/conexion.dart';
import 'package:policlinico_flores/models/fichas_model.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase FichasProvider para la consulta.
class FichasProvider {
  //Función asincrónica para la consulta de datos - READ.
  Future<List<FichaModel>> fichas() async {
    Database database = await Conexion.openDB();

    final List<Map<String, dynamic>> fichasMap =
        await database.query("fichas_view");

    //Leemos todos los campos.
    return List.generate(
      fichasMap.length,
      (i) => FichaModel(
          codigoficha: fichasMap[i]["codigo_ficha"],
          idconsulta: fichasMap[i]["id_consulta"],
          idpaciente: fichasMap[i]["id_paciente"],
          idusuario: fichasMap[i]["id_usuario"],
          area: fichasMap[i]["area_atencion"],
          motivo: fichasMap[i]["motivo"],
          fechaconsulta: fichasMap[i]["fecha_consulta"],
          nombres: fichasMap[i]["nombres"],
          apellidos: fichasMap[i]["apellidos"],
          dni: fichasMap[i]["dni"],
          edad: fichasMap[i]["edad"],
          genero: fichasMap[i]["genero"],
          telefono: fichasMap[i]["telefono"],
          fecharegistro: fichasMap[i]["fecha_registro"],
          especialista: fichasMap[i]["especialista"]),
    );
  }
}
