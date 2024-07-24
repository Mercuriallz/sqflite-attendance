import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE locations (
      id INTEGER PRIMARY KEY,
      name TEXT,
      latitude REAL,
      longitude REAL
    )
    ''');

    await db.execute('''
  CREATE TABLE attendances (
    id INTEGER PRIMARY KEY,
    locationId INTEGER,
    timestamp TEXT,
    latitude REAL,
    longitude REAL,
    FOREIGN KEY(locationId) REFERENCES locations(id)
  )
  ''');
  }

  // function untuk menambahkan lokasi

  Future<int> insertLocation(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('locations', row);
  }

  // function untuk mengambil semua lokasi

  Future<List<Map<String, dynamic>>> queryAllLocations() async {
    Database db = await database;
    return await db.query('locations');
  }
  
  // function untuk menambahkan absen
  Future<int> insertAttendance(Map<String, dynamic> row) async {
  Database db = await database;
  return await db.insert('attendances', row);
}

// function untuk mengambil riwayat absensi

Future<List<Map<String, dynamic>>> queryAllAttendances() async {
  Database db = await database;
  return await db.query('attendances');
}

Future<Map<String, dynamic>?> getLocationById(int locationId) async {
  Database db = await database;
  List<Map<String, dynamic>> result = await db.query(
    'locations',
    where: 'id = ?',
    whereArgs: [locationId],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
}
