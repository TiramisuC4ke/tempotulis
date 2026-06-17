import 'app_db.dart';
import 'package:sqflite/sqflite.dart';

import 'topic_row.dart';

// Note: TopicRow dipisah ke file topic_row.dart

class TopicRepo {
  Future<List<TopicRow>> getTopicsForUser(int userId) async {
    final db = await AppDb.instance.db;

    final rows = await db.query(
      'topics',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return rows
        .map((r) => TopicRow(
              id: (r['id'] as int),
              name: (r['name'] as String),
            ))
        .toList();
  }

  Future<int> addTopic(int userId, String name) async {
    final db = await AppDb.instance.db;

    return db.insert(
      'topics',
      {
        'user_id': userId,
        'name': name,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> deleteTopic(int userId, int topicId) async {
    final db = await AppDb.instance.db;

    await db.delete(
      'topics',
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, topicId],
    );
  }

  Future<void> updateTopic(int userId, int topicId, String name) async {
    final db = await AppDb.instance.db;

    await db.update(
      'topics',
      {
        'name': name,
      },
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, topicId],
    );
  }
}

