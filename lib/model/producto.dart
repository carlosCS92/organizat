///Clase que representa el objeto producto
class Producto {
  int? id;
  String nombre;
  int cantidad;
  String medida;
  int estanteId;

  Producto({
    this.id,
    required this.nombre,
    required this.cantidad,
    required this.medida,
    required this.estanteId,
  });

  /// Devuelve el objeto en formato Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
      'medida': medida,
      'estanteId': estanteId,
    };
  }

  /// Devuelve el objeto desde un Map
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      nombre: map['nombre'] ?? '',
      cantidad: map['cantidad'] ?? 1,
      medida: map['medida'] ?? 'Ud',
      estanteId: map['estanteId'],
    );
  }
}
