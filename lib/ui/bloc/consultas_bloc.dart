import 'dart:async';
import 'package:policlinico_flores/ui/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class ConsultasBloc with Validator {
  final _motivoController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get motivoStream =>
      _motivoController.stream.transform(validarMotivo);

  //Insertar valores al Stream
  Function(String) get changeMotivo => _motivoController.sink.add;

  //Obtener los últimos valores ingresados
  String get motivo => _motivoController.value;

  dispose() {
    _motivoController.close();
  }
}
