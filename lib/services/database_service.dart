import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/allergy.dart';

class DatabaseService {
  // Singleton pour l'objet Database
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Fonction pour créer explicitement la base de données
  Future<void> createDatabase() async {
    final db = await database;  // S'assure que la base de données est ouverte
    // Appel à _onCreate si la table est vide
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='allergies';");
    if (tables.isEmpty) {
      await _onCreate(db, 1);  // Crée la table si elle n'existe pas
      print("Base de données et table 'allergies' créées !");
    } else {
      print("La base de données existe déjà.");
    }
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'allergies.db');
    final db = await openDatabase(path, onCreate: _onCreate, version: 1);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE allergies(id INTEGER PRIMARY KEY AUTOINCREMENT, item TEXT)');
    await db.insert('allergies', {'item': 'en:e322i'});
    await db.insert('allergies', {'item': 'en:gluten'});
  }

  Future<List<Allergy>> allergies() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> map = await db.query('allergies');
    return List.generate(
        map.length,
        (index) => Allergy(
            id: map[index]['id'] as int, item: map[index]['item'] as String));
  }

  Future<void> delete(int id) async {
    final db = await _databaseService.database;
    await db.delete('allergies', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> add(String item) async {
    final db = await _databaseService.database;
    await db.insert('allergies', {'item': item});
  }
}
