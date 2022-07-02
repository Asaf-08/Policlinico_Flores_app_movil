import 'dart:async';
import 'package:policlinico_flores/ui/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class PagosBloc with Validator {
  final _montoController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get montoStream =>
      _montoController.stream.transform(validarMonto);

  //Insertar valores al Stream
  Function(String) get changeMonto => _montoController.sink.add;

  //Obtener los últimos valores ingresados
  String get monto => _montoController.value;

  dispose() {
    _montoController.close();
  }
}
