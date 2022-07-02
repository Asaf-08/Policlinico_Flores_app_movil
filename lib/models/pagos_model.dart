//Creación de la clase PagoModel con la definición del modelo de datos.
class PagoModel {
  int? idpago;
  int? idpaciente;
  int? idusuario;
  String? tipopago;
  num? montototal;
  String? fechapago;
  String? paciente;
  String? dni;

  //Constructor de la clase
  PagoModel(
      {this.idpago,
      this.idpaciente,
      this.idusuario,
      this.tipopago,
      this.montototal,
      this.fechapago,
      this.paciente,
      this.dni});

  //Conversión de PagoModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id_pago': idpago,
      'id_paciente': idpaciente,
      'id_usuario': idusuario,
      'tipo_pago': tipopago,
      'monto_total': montototal,
      'fecha_pago': fechapago
    };
  }

  @override
  String toString() {
    return 'Pago{id: $idpago, idpaciente: $idpaciente, idusuario: $idusuario, tipopago: $tipopago, montototal: $montototal, fecha_pago: $fechapago, paciente: $paciente, dni: $dni}';
  }
}
