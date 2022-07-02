//Creación de la clase PacienteModel con la definición del modelo de datos.
class PacienteModel {
  int? idpaciente;
  int? idusuario;
  String? nombres;
  String? apellidos;
  String? dni;
  int? edad;
  String? genero;
  String? telefono;
  String? fecharegistro;

  //Constructor de la clase
  PacienteModel(
      {this.idpaciente,
      this.idusuario,
      this.nombres,
      this.apellidos,
      this.dni,
      this.edad,
      this.genero,
      this.telefono,
      this.fecharegistro});

  //Conversión de PacienteModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id_paciente': idpaciente,
      'id_usuario': idusuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'dni': dni,
      'edad': edad,
      'genero': genero,
      'telefono': telefono,
      'fecha_registro': fecharegistro
    };
  }

  @override
  String toString() {
    return 'Paciente{id: $idpaciente, idusuario: $idusuario, nombres: $nombres, apellidos: $apellidos, dni: $dni, edad: $edad, genero: $genero, telefono: $telefono, fecha registro: $fecharegistro}';
  }
}
