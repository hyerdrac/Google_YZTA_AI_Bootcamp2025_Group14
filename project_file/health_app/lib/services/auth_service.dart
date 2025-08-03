import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kayıt ol
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Kayıt sırasında hata oluştu.';
    }
  }

  // Giriş yap
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Giriş sırasında hata oluştu.';
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Kullanıcı durumu stream'i
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}