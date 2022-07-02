import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Creación de la clase para la conexión con la base de datos
class Conexion {
  static Future _onConfigure(Database db) async {
    //Habilitamos la lectura de las Foreign Key
    await db.execute('PRAGMA foreign_keys = ON');
  }

  //Pasamos el archivo de la base datos al dispositivo
  static Future<Database> openDB() async {
    final String dbDir = await getDatabasesPath();
    final String dbPath = join(dbDir, "policlinico_flores.db");
    final File file = File(dbPath);

    //Comprobamos si el nombre del archivo ya existe
    if (!file.existsSync()) {
      print("Copiando base de datos");
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
      } catch (_) {}

      //De no existir, copiamos la estructura e información del archivo
      ByteData data = await rootBundle
          .load(join("assets/database", "policlinico_flores.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(dbPath).writeAsBytes(bytes, flush: true);
      print("Base de datos copiada en $dbPath");
    }

    //Abrimos la base de datos con la propiedad onConfigura para que se lea correctamente las Foreign Key
    final database = openDatabase(dbPath, onConfigure: _onConfigure);

    return database;
  }
}
