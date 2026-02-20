import 'package:organiza_t/model/Espacio.dart';
import 'package:organiza_t/database/AlmacenamientoSQLite.dart';

///CRUD de la tabla espacios
class EspacioCrud {
  ///Agrega un espacio
  static Future<int> agregarEspacio(Espacio espacio) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    int id = await db.insert('espacios', espacio.toMap());
    return id;
  }

  /// Modifica el nombre de un espacio
  static Future<int> modificarEspacio(Espacio espacio) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    int filas = await db.update(
      "espacios",
      espacio.toMap(),
      where: "id = ?",
      whereArgs: [espacio.id],
    );
    return filas;
  }

  ///Elimina un espacio
  static Future<void> eliminarEspacio(int id) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    await db.delete("espacios", where: "id = ?", whereArgs: [id]);
  }

  /// Se obtienen todos los espacios
  static Future<List<Espacio>> obtenerTodosEspacios() async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    final result = await db.query("espacios");
    return result.map((map) => Espacio.fromMap(map)).toList();
  }
}
