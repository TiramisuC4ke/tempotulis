import 'app_db.dart';

class NoteRow {
  final int id;
  final int topicId;
  final String title;
  final String content;
  final String noteDate;
  final String topicName;

  NoteRow({
    required this.id,
    required this.topicId,
    required this.title,
    required this.content,
    required this.noteDate,
    required this.topicName,
  });
}

class NoteRepo {
  Future<List<NoteRow>> getNotesForUser(int userId) async {
    final db = await AppDb.instance.db;

    final rows = await db.rawQuery('''
      SELECT
        n.id,
        n.topic_id,
        n.title,
        n.content,
        n.note_date,
        t.name AS topic_name
      FROM notes n
      INNER JOIN topics t ON t.id = n.topic_id
      WHERE n.user_id = ?
      ORDER BY n.note_date DESC, n.id DESC
    ''', [userId]);

    return rows
        .map((r) => NoteRow(
              id: r['id'] as int,
              topicId: r['topic_id'] as int,
              title: r['title'] as String,
              content: r['content'] as String,
              noteDate: r['note_date'] as String,
              topicName: r['topic_name'] as String,
            ))
        .toList();
  }

  Future<List<NoteRow>> searchNotesForUser(
    int userId,
    String query,
  ) async {
    final db = await AppDb.instance.db;

    final q = '%${query.toLowerCase()}%';

    final rows = await db.rawQuery('''
      SELECT
        n.id,
        n.topic_id,
        n.title,
        n.content,
        n.note_date,
        t.name AS topic_name
      FROM notes n
      INNER JOIN topics t ON t.id = n.topic_id
      WHERE n.user_id = ?
        AND (
          LOWER(n.title) LIKE ? OR
          LOWER(n.content) LIKE ? OR
          LOWER(t.name) LIKE ?
        )
      ORDER BY n.note_date DESC, n.id DESC
    ''', [userId, q, q, q]);

    return rows
        .map((r) => NoteRow(
              id: r['id'] as int,
              topicId: r['topic_id'] as int,
              title: r['title'] as String,
              content: r['content'] as String,
              noteDate: r['note_date'] as String,
              topicName: r['topic_name'] as String,
            ))
        .toList();
  }

  Future<int> addNote({
    required int userId,
    required int topicId,
    required String title,
    required String content,
    required String noteDate,
  }) async {
    final db = await AppDb.instance.db;

    return db.insert('notes', {
      'user_id': userId,
      'topic_id': topicId,
      'title': title,
      'content': content,
      'note_date': noteDate,
    });
  }

  Future<void> updateNote({
    required int userId,
    required int noteId,
    required int topicId,
    required String title,
    required String content,
    required String noteDate,
  }) async {
    final db = await AppDb.instance.db;

    await db.update(
      'notes',
      {
        'topic_id': topicId,
        'title': title,
        'content': content,
        'note_date': noteDate,
      },
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, noteId],
    );
  }

  Future<void> deleteNote({
    required int userId,
    required int noteId,
  }) async {
    final db = await AppDb.instance.db;

    await db.delete(
      'notes',
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, noteId],
    );
  }
}

