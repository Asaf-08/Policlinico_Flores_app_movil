//Creación de la clase UsuarioModel con la definición del modelo de datos.
class UsuarioModel {
  int? idusuario;
  int? idrol;
  String? nombres;
  String? apellidos;
  String? email;
  String? usuario;
  String? password;

  //Constructor de la clase
  UsuarioModel(
      {this.idusuario,
      this.idrol,
      this.nombres,
      this.apellidos,
      this.email,
      this.usuario,
      this.password});

  //Conversión de UsuarioModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idusuario,
      'id_rol': idrol,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'usuario': usuario,
      'password': password
    };
  }

  //Recuperación de datos del Map
  UsuarioModel.fromMap(Map<String, dynamic> map) {
    idusuario = map['id_usuario'];
    idrol = map['id_rol'];
    nombres = map['nombres'];
    apellidos = map['apellidos'];
    email = map['email'];
    usuario = map['usuario'];
    password = map['password'];
  }

  @override
  String toString() {
    return 'Usuario{id: $idusuario, idrol: $idrol, nombres: $nombres, apellidos: $apellidos, email: $email, usuario: $usuario, password: $password}';
  }
}
