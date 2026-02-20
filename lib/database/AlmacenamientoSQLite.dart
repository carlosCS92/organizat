import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SERVICIO DE ALMACENAMIENTO CON SQLITE
// ═══════════════════════════════════════════════════════════════════════════

/// Servicio para gestionar la base de datos SQLite
class AlmacenamientoSQLite {
  static Database? _database;

  // ══════════════════════════════════════════════════════════════════════════
  // INICIALIZACIÓN Y SCHEMA
  // ══════════════════════════════════════════════════════════════════════════

  /// Obtener instancia de la base de datos
  static Future<Database> obtenerBD() async {
    if (_database != null) return _database!;
    _database = await _inicializarBD();
    return _database!;
  }

  /// Inicializar la base de datos y crear tablas
  static Future<Database> _inicializarBD() async {
    final String ruta = join(await getDatabasesPath(), 'organizate.db');

    return await openDatabase(
      ruta,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async {
        // Crear tabla de Espacios
        await db.execute('''
          CREATE TABLE espacios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL
          )
        ''');

        // Crear tabla de Estantes
        await db.execute('''
          CREATE TABLE estantes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            espacioId INTEGER NOT NULL,
            nombre TEXT NOT NULL,
            FOREIGN KEY (espacioId) REFERENCES espacios(id) ON DELETE CASCADE
          )
        ''');

        //Crear tabla de Productos
        await db.execute('''
          CREATE TABLE productos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            estanteId INTEGER NOT NULL,
            nombre TEXT NOT NULL,
            cantidad INTEGER NOT NULL,
            FOREIGN KEY (estanteId) REFERENCES estantes(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
