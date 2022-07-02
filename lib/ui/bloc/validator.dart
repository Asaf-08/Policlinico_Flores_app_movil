import 'dart:async';

class Validator {
  //Validar nombre
  final validarNombres = StreamTransformer<String, String>.fromHandlers(
    handleData: (nombres, sink) {
      String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
      RegExp regExp = RegExp(pattern);
      if (nombres.isEmpty) {
        sink.addError('Ingrese los nombres.');
      } else if (regExp.hasMatch(nombres)) {
        sink.addError('Ingrese nombres válidos.');
      } else {
        sink.add(nombres);
      }
    },
  );

  //Validar apellido
  final validarApellidos = StreamTransformer<String, String>.fromHandlers(
    handleData: (apellidos, sink) {
      String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
      RegExp regExp = RegExp(pattern);
      if (apellidos.isEmpty) {
        sink.addError('Ingrese los apellidos.');
      } else if (apellidos.isEmpty || regExp.hasMatch(apellidos)) {
        sink.addError('Ingrese apellidos válidos.');
      } else {
        sink.add(apellidos);
      }
    },
  );

  //Validar DNI
  final validarDNI = StreamTransformer<String, String>.fromHandlers(
    handleData: (dni, sink) {
      String pattern = r'(^(?:[+0]9)?[0-9]{8}$)';
      RegExp regExp = RegExp(pattern);
      if (dni.isEmpty) {
        sink.addError('Ingrese el DNI del paciente.');
      } else if (!regExp.hasMatch(dni)) {
        sink.addError('Ingrese un DNI válido.');
      } else {
        sink.add(dni);
      }
    },
  );

  //Validar teléfono
  final validarPhone = StreamTransformer<String, String>.fromHandlers(
    handleData: (telefono, sink) {
      String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
      RegExp regExp = RegExp(pattern);
      if (telefono.isEmpty) {
        sink.addError('Ingrese el teléfono.');
      } else if (!regExp.hasMatch(telefono)) {
        sink.addError('Teléfono inválido.');
      } else {
        sink.add(telefono);
      }
    },
  );

  //Validar motivo
  final validarMotivo = StreamTransformer<String, String>.fromHandlers(
    handleData: (motivo, sink) {
      if (motivo.isEmpty) {
        sink.addError('Ingrese el motivo de la consulta.');
      } else {
        sink.add(motivo);
      }
    },
  );

  //Validar monto
  final validarMonto = StreamTransformer<String, String>.fromHandlers(
    handleData: (monto, sink) {
      String pattern = r'^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1,4})?$';
      RegExp regExp = RegExp(pattern);
      if (monto.isEmpty) {
        sink.addError('Ingrese el monto total.');
      } else if (!regExp.hasMatch(monto)) {
        sink.addError('Monto inválido.');
      } else {
        sink.add(monto);
      }
    },
  );

  //Validar usuario
  final validarUsuario = StreamTransformer<String, String>.fromHandlers(
    handleData: (usuario, sink) {
      if (usuario.isEmpty) {
        sink.addError('Ingrese el usuario.');
      } else if (usuario.length < 6) {
        sink.addError('Ingrese 6 caracteres como mínimo.');
      } else {
        sink.add(usuario);
      }
    },
  );

  //Validar email
  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);

      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Ingrese un email válido.');
      }
    },
  );

  //Validar contraseña
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.isEmpty) {
        sink.addError('Ingrese la contraseña.');
      } else if (password.length < 6) {
        sink.addError('Ingrese 6 caracteres como mínimo.');
      } else {
        sink.add(password);
      }
    },
  );

  //Validar confirmar contraseña
  final validarConfirmPass = StreamTransformer<String, String>.fromHandlers(
    handleData: (confirmpass, sink) {
      if (confirmpass.isEmpty) {
        sink.addError('Confirme la contraseña.');
      } else {
        sink.add(confirmpass);
      }
    },
  );
}
