import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    // Database kamu ada di:
    // C:\Users\LENOVO\project_ppm.db
    // Untuk platform yang berbeda, path file bisa beda, jadi default-nya ambil dari dokumen lokal.
    // Jika file tidak ada di lokasi itu, kita fallback ke folder kerja/dev root (tidak selalu ada di mobile).

    final docsDir = await getApplicationDocumentsDirectory();

    // Coba pakai file asli yang ada di C:\Users\LENOVO\project_ppm.db kalau masih tersedia.
    final forcedPath = r'C:\Users\LENOVO\project_ppm.db';
    final forcedFile = File(forcedPath);

    final targetPath = forcedFile.existsSync()
        ? forcedPath
        : '${docsDir.path}/project_ppm.db';

    // Pastikan folder tujuan ada
    if (!forcedFile.existsSync()) {
      final targetFile = File(targetPath);
      final targetFolder = File(targetPath).parent;
      if (!targetFolder.existsSync()) {
        await targetFolder.create(recursive: true);
      }

      // Kalau database tidak ada di target, maka inisialisasi lewat sqflite akan gagal.
      // Untuk saat ini kita hanya membuka database yang sudah ada.
      // (Kalau kamu ingin, nanti bisa dibuat mekanisme copy dari assets.)
    }

    return openDatabase(
      targetPath,
      version: 1,
      readOnly: true,
    );
  }

  Future<void> close() async {
    final d = _db;
    _db = null;
    if (d != null) {
      await d.close();
    }
  }
}

