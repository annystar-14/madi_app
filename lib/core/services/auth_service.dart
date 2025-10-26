import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_app/core/database/db_helper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DBHelper _db = DBHelper();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

Future<void> signIn(String email, String password) async {
  final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
  final token = await userCred.user?.getIdToken();
  if (token != null) {
    await _db.insertUser(email, token); // guarda usuario localmente
  }
}

  Future<void> signUp(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final token = await userCred.user?.getIdToken();
    if (token != null) {
      await _db.insertUser(email, token);
    }
  }

Future<void> signOut() async {
  final user = _auth.currentUser;
  if (user != null) {
    await _db.deleteUser(user.email!); // elimina sesión local
  }
  await _auth.signOut();
}

  Future<Map<String, dynamic>?> getLocalUser(String email) async {
    return await _db.getUser(email);
  }
}
