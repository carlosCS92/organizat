///Clase que representa el objeto estante
class Estante {
  int? id;
  int espacioId;
  String nombre;

  Estante({this.id, required this.espacioId, required this.nombre});

  ///Devuleve el Map del objeto
  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'espacioId': espacioId};
  }

  /// Devuelve el objeto desde un Map
  factory Estante.fromMap(Map<String, dynamic> map) {
    return Estante(
      id: map['id'],
      nombre: map['nombre'] ?? '',
      espacioId: map['espacioId'],
    );
  }
}
