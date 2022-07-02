import 'package:policlinico_flores/ui/pages/home.dart';

typedef Constructor<T> = T Function();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

//Obtenemos las clases
class ClassBuilder {
  static void registerClasses() {
    register<HomeAdmin>(() => HomeAdmin());
    register<HomeUser>(() => HomeUser());
  }

  //Obtener el nombre de la clase en forma de cadena
  static dynamic fromString(String type) {
    if (_constructors[type] != null) {
      return _constructors[type]!();
    }
  }
}
