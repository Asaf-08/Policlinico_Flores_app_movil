import 'dart:async';
import 'package:policlinico_flores/ui/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc with Validator {
  final nombresController = BehaviorSubject<String>();
  final apellidosController = BehaviorSubject<String>();
  final usuarioController = BehaviorSubject<String>();
  final emailController = BehaviorSubject<String>();
  final passwordController = BehaviorSubject<String>();
  final confirmpassController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get nombresStream =>
      nombresController.stream.transform(validarNombres);
  Stream<String> get apellidosStream =>
      apellidosController.stream.transform(validarApellidos);
  Stream<String> get usuarioStream =>
      usuarioController.stream.transform(validarUsuario);
  Stream<String> get emailStream =>
      emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      passwordController.stream.transform(validarPassword).doOnData((String c) {
        if (0 != confirmpassController.value.compareTo(c)) {
          confirmpassController.addError("Las contraseñas no coinciden.");
        } else {
          confirmpassController.add(confirmpassController.value);
        }
      });
  Stream<String> get confirmpassStream => confirmpassController.stream
          .transform(validarPassword)
          .doOnData((String c) {
        if (0 != passwordController.value.compareTo(c)) {
          confirmpassController.addError("Las contraseñas no coinciden.");
        }
      });

  Stream<bool> get formValidStream => Rx.combineLatest6(
      nombresStream,
      apellidosStream,
      usuarioStream,
      emailStream,
      passwordStream,
      confirmpassStream,
      (n, a, u, e, p, cp) => true);

  //Insertar valores al Stream
  Function(String) get changeNombres => nombresController.sink.add;
  Function(String) get changeApellidos => apellidosController.sink.add;
  Function(String) get changeUsuario => usuarioController.sink.add;
  Function(String) get changeEmail => emailController.sink.add;
  Function(String) get changePassword => passwordController.sink.add;
  Function(String) get changeConfirmPass => confirmpassController.sink.add;

  //Obtener los últimos valores ingresados
  String get nombres => nombresController.value;
  String get apellidos => apellidosController.value;
  String get usuario => usuarioController.value;
  String get email => emailController.value;
  String get password => passwordController.value;
  String get confirmpass => confirmpassController.value;

  dispose() {
    nombresController.close();
    apellidosController.close();
    usuarioController.close();
    emailController.close();
    passwordController.close();
    confirmpassController.close();
  }
}
