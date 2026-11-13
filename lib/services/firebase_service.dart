import 'package:firebase_database/firebase_database.dart';
import '../models/usuario.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference _usuarioRef(String uid) => _db.ref('usuarios/$uid');

  Future<void> salvarUsuario(Usuario usuario) {
    return _usuarioRef(usuario.uid).set(usuario.toMap());
  }
}