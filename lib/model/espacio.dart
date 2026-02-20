/// Clase que representa el objeto espacio
class Espacio {
  int? id;
  String nombre;

  Espacio({this.id, required this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre};
  }

  factory Espacio.fromMap(Map<String, dynamic> map) {
    return Espacio(id: map['id'], nombre: map['nombre'] ?? '');
  }
}
