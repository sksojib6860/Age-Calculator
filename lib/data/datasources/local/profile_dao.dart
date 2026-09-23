import 'package:sqflite/sqflite.dart';
import '../../models/profile_model.dart';
import 'app_database.dart';

/// Data Access Object for SQLite profiles table
class ProfileDao {
  final AppDatabase dbManager;

  ProfileDao({AppDatabase? db}) : dbManager = db ?? AppDatabase.instance;

  Future<void> insert(ProfileModel model) async {
    final db = await dbManager.database;
    await db.insert(
      'profiles',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(ProfileModel model) async {
    final db = await dbManager.database;
    await db.update(
      'profiles',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await dbManager.database;
    await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ProfileModel>> getAll() async {
    final db = await dbManager.database;
    final results = await db.query(
      'profiles',
      orderBy: 'name ASC',
    );
    return results.map((map) => ProfileModel.fromMap(map)).toList();
  }

  Future<ProfileModel?> getById(String id) async {
    final db = await dbManager.database;
    final results = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return ProfileModel.fromMap(results.first);
  }
}
