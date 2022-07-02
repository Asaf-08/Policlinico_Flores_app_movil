//Creación de la clase FichaModel con la definición del modelo de datos.
class FichaModel {
  int? codigoficha;
  int? idconsulta;
  int? idpaciente;
  int? idusuario;
  String? area;
  String? motivo;
  String? fechaconsulta;
  String? nombres;
  String? apellidos;
  String? dni;
  int? edad;
  String? genero;
  String? telefono;
  String? fecharegistro;
  String? especialista;

  //Constructor de la clase
  FichaModel(
      {this.codigoficha,
      this.idconsulta,
      this.idpaciente,
      this.idusuario,
      this.area,
      this.motivo,
      this.fechaconsulta,
      this.nombres,
      this.apellidos,
      this.dni,
      this.edad,
      this.genero,
      this.telefono,
      this.fecharegistro,
      this.especialista});

  @override
  String toString() {
    return 'Consulta{código: $codigoficha, idconsulta: $idconsulta, idpaciente: $idpaciente, idusuario: $idusuario, area_atencion: $area, motivo: $motivo, fecha_consulta: $fechaconsulta, paciente: $apellidos, $nombres, dni: $dni}';
  }
}
