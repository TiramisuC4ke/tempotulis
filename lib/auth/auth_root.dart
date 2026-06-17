import 'package:flutter/material.dart';

import 'auth_manager.dart';
import 'login_page.dart';

import '../main.dart';

class AuthRoot extends StatefulWidget {
  const AuthRoot({super.key});

  @override
  State<AuthRoot> createState() => _AuthRootState();
}

class _AuthRootState extends State<AuthRoot> {
  @override
  void initState() {
    super.initState();

    // Supaya UI berubah saat login/logout, kita pakai rebuild sederhana.
    // Karena AuthManager saat ini hanya menyimpan state sederhana,
    // kita trigger reload setelah navigasi login.
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthManager.instance;

    if (!auth.isLoggedIn) {
      return const LoginPage();
    }

    // Gunakan existing UI di main.dart untuk sementara.
    // Pada tahap berikutnya, main.dart akan diganti untuk mengambil data dari DB.
    return const MainPage();
  }
}

