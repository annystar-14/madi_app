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
        try {
            await _db.insertUser(email, token); 
            } catch (e) {
              print('Advertencia: Falló al guardar el token localmente: $e');
            }
      }
  }

  Future<void> signUp(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final token = await userCred.user?.getIdToken();
        
    if (token != null) {
      try {
            await _db.insertUser(email, token);
          } catch (e) {
              print('Advertencia: Falló al guardar el token después del registro: $e');
          }
      }
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    
    if (user != null) {
      try {
        await _db.deleteUser(user.email!); 
      } catch (e) {
        print('Advertencia: Falló al eliminar el usuario localmente: $e');
      }
    }
    
    await _auth.signOut();
  }
}
