import 'package:organiza_t/model/estante.dart';
import 'package:organiza_t/database/AlmacenamientoSQLite.dart';

///CRUD de la tabla estantes
class EstanteCrud {
  ///Añadir un nuevo estante
  static Future<int> agregarEstante(Estante estante) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    int id = await db.insert('estantes', estante.toMap());
    return id;
  }

  ///Modificar un estante
  static Future<int> modificarEstante(Estante estante) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    int id = await db.update(
      "estantes",
      estante.toMap(),
      where: "id = ?",
      whereArgs: [estante.id],
    );
    return id;
  }

  ///Eliminar un estante
  static Future<void> eliminarEstante(int id) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    await db.delete("estantes", where: "id = ?", whereArgs: [id]);
  }

  ///Listar los estantes de un espacio
  static Future<List<Estante>> obtenerEstantesPorEspacio(int idEspacio) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    final result = await db.query(
      "estantes",
      where: "espacioId = ?",
      whereArgs: [idEspacio],
    );
    return result.map((map) => Estante.fromMap(map)).toList();
  }
}
