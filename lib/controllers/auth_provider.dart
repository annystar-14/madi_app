import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_app/core/services/auth_service.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  ref.keepAlive();
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(null) {
    _authService.authStateChanges.listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
    state = FirebaseAuth.instance.currentUser;
  }

  Future<void> signUp(String email, String password) async {
    await _authService.signUp(email, password);
    state = FirebaseAuth.instance.currentUser;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}