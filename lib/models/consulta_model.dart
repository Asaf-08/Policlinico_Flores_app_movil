//Creación de la clase ConsultaModel con la definición del modelo de datos.
class ConsultaModel {
  int? idconsulta;
  int? idpaciente;
  int? idusuario;
  String? area;
  String? motivo;
  String? fechaconsulta;
  String? paciente;
  String? dni;

  //Constructor de la clase
  ConsultaModel(
      {this.idconsulta,
      this.idpaciente,
      this.idusuario,
      this.area,
      this.motivo,
      this.fechaconsulta,
      this.paciente,
      this.dni});

  //Conversión de ConsultaModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id_consulta': idconsulta,
      'id_paciente': idpaciente,
      'id_usuario': idusuario,
      'area_atencion': area,
      'motivo': motivo,
      'fecha_consulta': fechaconsulta
    };
  }

  @override
  String toString() {
    return 'Consulta{id: $idconsulta, idpaciente: $idpaciente, idusuario: $idusuario, area_atencion: $area, motivo: $motivo, fecha_consulta: $fechaconsulta, paciente: $paciente, dni: $dni}';
  }
}
