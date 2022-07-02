//Creación de la clase CitaModel con la definición del modelo de datos.
class CitaModel {
  int? idcita;
  int? idusuario;
  String? area;
  String? fechacita;
  String? horariocita;
  String? nombres;
  String? apellidos;
  int? estado;

  //Constructor de la clase
  CitaModel(
      {this.idcita,
      this.idusuario,
      this.area,
      this.fechacita,
      this.horariocita,
      this.nombres,
      this.apellidos,
      this.estado});

  //Conversión de CitaModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id_cita': idcita,
      'id_usuario': idusuario,
      'area_atencion': area,
      'fecha_cita': fechacita,
      'horario_cita': horariocita,
      'estado': estado
    };
  }

  @override
  String toString() {
    return 'Citas{id: $idcita, idusuario: $idusuario, area_atencion: $area, fecha_cita: $fechacita, horario_cita: $horariocita, usuario: $apellidos, $nombres, estado: $estado}';
  }
}
