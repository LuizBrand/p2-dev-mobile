import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../models/tarefa.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference _usuarioRef(String uid) => _db.ref('usuarios/$uid');

  DatabaseReference get _tarefasRef {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Nenhum usuário logado.');
    }
    return _db.ref('tarefas/$uid');
  }

  Future<void> salvarUsuario(Usuario usuario) {
    return _usuarioRef(usuario.uid).set(usuario.toMap());
  }

  Stream<List<Tarefa>> tarefasStream() {
    return _tarefasRef.onValue.map((event) {
      final dados = event.snapshot.value;
      if (dados is! Map) return <Tarefa>[];

      final tarefas = dados.entries
          .map((e) => Tarefa.fromMap(e.key.toString(), e.value as Map))
          .toList();
      tarefas.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return tarefas;
    });
  }

  Stream<Tarefa?> tarefaStream(String id) {
    return _tarefasRef.child(id).onValue.map((event) {
      final dados = event.snapshot.value;
      if (dados is! Map) return null;
      return Tarefa.fromMap(id, dados);
    });
  }

  Future<void> adicionarTarefa(Tarefa tarefa) {
    return _tarefasRef.push().set(tarefa.toMap());
  }

  Future<void> atualizarTarefa(Tarefa tarefa) {
    return _tarefasRef.child(tarefa.id!).set(tarefa.toMap());
  }

  Future<void> excluirTarefa(String id) {
    return _tarefasRef.child(id).remove();
  }

  Future<void> alternarSituacao(Tarefa tarefa) {
    return _tarefasRef
        .child(tarefa.id!)
        .update({'concluida': !tarefa.concluida});
  }
}