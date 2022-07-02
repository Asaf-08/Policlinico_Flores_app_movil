import 'dart:async';
import 'package:policlinico_flores/ui/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validator {
  final usuarioController = BehaviorSubject<String>();
  final passwordController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get usuarioStream =>
      usuarioController.stream.transform(validarUsuario);
  Stream<String> get passwordStream =>
      passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(usuarioStream, passwordStream, (u, p) => true);

  //Insertar valores al Stream
  Function(String) get changeUsuario => usuarioController.sink.add;
  Function(String) get changePassword => passwordController.sink.add;

  //Obtener los últimos valores ingresados
  String get usuario => usuarioController.value;
  String get password => passwordController.value;

  dispose() {
    usuarioController.close();
    passwordController.close();
  }
}
