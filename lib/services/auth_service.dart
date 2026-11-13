import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import 'firebase_service.dart';

class AuthException implements Exception {
  final String mensagem;

  AuthException(this.mensagem);

  @override
  String toString() => mensagem;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();

  Stream<Usuario?> get usuarioStream => _auth.userChanges().map(_converter);

  Usuario? get usuarioAtual => _converter(_auth.currentUser);

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final user = credencial.user!;

      await user.updateDisplayName(nome);

      await _firebaseService.salvarUsuario(
        Usuario(uid: user.uid, nome: nome, email: email),
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduzirErro(e.code));
    }
  }

  Future<void> login({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduzirErro(e.code));
    }
  }

  Future<void> logout() => _auth.signOut();

  Usuario? _converter(User? user) {
    if (user == null) return null;
    return Usuario(
      uid: user.uid,
      nome: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  String _traduzirErro(String codigo) {
    return switch (codigo) {
      'invalid-email' => 'E-mail inválido.',
      'user-disabled' => 'Esta conta foi desativada.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' =>
      'E-mail ou senha incorretos.',
      'email-already-in-use' => 'Este e-mail já está cadastrado.',
      'weak-password' => 'Senha fraca. Use pelo menos 6 caracteres.',
      'too-many-requests' =>
      'Muitas tentativas. Aguarde um pouco e tente novamente.',
      'network-request-failed' => 'Sem conexão com a internet.',
      'operation-not-allowed' =>
      'Login por e-mail e senha não está habilitado no Firebase.',
      _ => 'Erro de autenticação ($codigo).',
    };
  }
}