import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_app/core/services/auth_service.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(null) {
    //  Antes: _authService.authStateChanges().listen(...)
    //  Ahora:
    _authService.authStateChanges.listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
