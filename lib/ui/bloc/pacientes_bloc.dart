import 'dart:async';
import 'package:policlinico_flores/ui/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class PacientesBloc with Validator {
  final _nombresController = BehaviorSubject<String>();
  final _apellidosController = BehaviorSubject<String>();
  final _dniController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get nombresStream =>
      _nombresController.stream.transform(validarNombres);
  Stream<String> get apellidosStream =>
      _apellidosController.stream.transform(validarApellidos);
  Stream<String> get dniStream => _dniController.stream.transform(validarDNI);
  Stream<String> get phoneStream =>
      _phoneController.stream.transform(validarPhone);

  Stream<bool> get formValidStream => Rx.combineLatest4(nombresStream,
      apellidosStream, dniStream, phoneStream, (n, a, d, p) => true);

  //Insertar valores al Stream
  Function(String) get changeNombres => _nombresController.sink.add;
  Function(String) get changeApellidos => _apellidosController.sink.add;
  Function(String) get changeDNI => _dniController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;

  //Obtener los últimos valores ingresados
  String get nombres => _nombresController.value;
  String get apellidos => _apellidosController.value;
  String get dni => _dniController.value;
  String get telefono => _phoneController.value;

  dispose() {
    _nombresController.close();
    _apellidosController.close();
    _dniController.close();
    _phoneController.close();
  }
}
