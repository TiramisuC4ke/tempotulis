import 'package:sqflite/sqflite.dart';
import 'app_db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthRepo {
  Future<int?> login(String username, String password) async {
    final db = await AppDb.instance.db;

    final passwordHash = _hashPassword(password);

    final rows = await db.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, passwordHash],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return (rows.first['id'] as int?)!;
  }

  Future<int> register({
    required String username,
    required String password,
  }) async {
    final db = await AppDb.instance.db;

    final passwordHash = _hashPassword(password);

    // users.username UNIQUE, jadi akan error jika sama.
    final id = await db.insert(
      'users',
      {
        'username': username,
        'password_hash': passwordHash,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return id;
  }

  String _hashPassword(String password) {
    // Untuk konsistensi, hash menggunakan SHA-256.
    // Pastikan saat kamu membuat user, password_hash juga memakai skema ini.
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}


