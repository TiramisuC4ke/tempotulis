class AuthManager {
  AuthManager._();
  static final AuthManager instance = AuthManager._();

  int? currentUserId;

  bool get isLoggedIn => currentUserId != null;

  void login(int userId) {
    currentUserId = userId;
  }

  void logout() {
    currentUserId = null;
  }
}

