import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

import '../models/resena.dart';

class ResenasDb {
  ResenasDb._();

  static final ResenasDb instancia = ResenasDb._();

  static const String _tabla = 'resenas';
  static const String _nombreArchivo = 'resenas.db';

  sqflite.Database? _db;

  Future<sqflite.Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<sqflite.Database> _initDb() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      ffi.sqfliteFfiInit();
      sqflite.databaseFactory = ffi.databaseFactoryFfi;
    }

    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, _nombreArchivo);

    return sqflite.openDatabase(path, version: 1, onCreate: _crearTabla);
  }

  Future<void> _crearTabla(sqflite.Database db, int version) async {
    await db.execute(
      'CREATE TABLE $_tabla ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'recetaId INTEGER NOT NULL, '
      'usuarioId INTEGER NOT NULL DEFAULT 1, '
      'valoracion INTEGER NOT NULL CHECK ('
      'valoracion BETWEEN 1 AND 5 AND typeof(valoracion) = \'integer\'), '
      'resena TEXT NOT NULL'
      ')',
    );
  }

  Future<int> insertar(Resena resena) async {
    final db = await database;
    return db.insert(_tabla, resena.toMap());
  }

  Future<List<Resena>> obtenerPorReceta(int recetaId) async {
    final db = await database;
    final filas = await db.query(
      _tabla,
      where: 'recetaId = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );
    return filas.map(Resena.fromMap).toList();
  }
}
