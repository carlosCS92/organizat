import 'package:organiza_t/model/producto.dart';
import 'package:organiza_t/database/AlmacenamientoSQLite.dart';

///CRUD de la tabla productos
class ProductoCrud {
  ///Agregar un nuevo producto
  static Future<int> agregarProducto(Producto producto) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    int id = await db.insert('productos', producto.toMap());
    return id;
  }

  ///Modificar un producto
  static Future<int> modificarProducto(Producto producto) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    int id = await db.update(
      "productos",
      producto.toMap(),
      where: "id = ?",
      whereArgs: [producto.id],
    );

    ///Si la cantidad del producto es 0, se elimina el producto
    if (producto.cantidad == 0) {
      eliminarProducto(producto.id!);
    }

    return id;
  }

  ///Eliminar un producto
  static Future<void> eliminarProducto(int id) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    await db.delete("productos", where: "id = ?", whereArgs: [id]);
  }

  ///Listar los productos de un estante
  static Future<List<Producto>> obtenerProductosPorEstante(
    int idEstante,
  ) async {
    final db = await AlmacenamientoSQLite.obtenerBD();
    final result = await db.query(
      "productos",
      where: "estanteId = ?",
      whereArgs: [idEstante],
    );
    return result.map((map) => Producto.fromMap(map)).toList();
  }
}
