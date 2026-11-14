import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import 'cadastro_tarefa_screen.dart';

class DetalheTarefaScreen extends StatefulWidget {
  final Tarefa tarefa;

  const DetalheTarefaScreen({super.key, required this.tarefa});

  @override
  State<DetalheTarefaScreen> createState() => _DetalheTarefaScreenState();
}

class _DetalheTarefaScreenState extends State<DetalheTarefaScreen> {
  final _firebaseService = FirebaseService();

  late final Stream<Tarefa?> _tarefaStream =
  _firebaseService.tarefaStream(widget.tarefa.id!);

  void _editar(Tarefa tarefa) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CadastroTarefaScreen(tarefa: tarefa)),
    );
  }

  Future<void> _alternarSituacao(Tarefa tarefa) async {
    try {
      await _firebaseService.alternarSituacao(tarefa);
    } catch (_) {
      _mostrarErro('Não foi possível alterar a situação.');
    }
  }

  Future<void> _excluir(Tarefa tarefa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text(
          'Deseja excluir "${tarefa.titulo}"? Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    navigator.pop();
    try {
      await _firebaseService.excluirTarefa(tarefa.id!);
      messenger.showSnackBar(
        const SnackBar(content: Text('Tarefa excluída.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir a tarefa.')),
      );
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: colorScheme.onError)),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<Tarefa?>(
      stream: _tarefaStream,
      initialData: widget.tarefa,
      builder: (context, snapshot) {
        final tarefa = snapshot.data;

        if (tarefa == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes da tarefa')),
            body: const Center(child: Text('Tarefa não encontrada.')),
          );
        }

        final prioridade = tarefa.prioridade;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes da tarefa'),
            actions: [
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editar(tarefa),
              ),
              IconButton(
                tooltip: 'Excluir',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _excluir(tarefa),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(tarefa.titulo, style: textTheme.headlineSmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: Icon(prioridade.icone, color: prioridade.cor, size: 18),
                    label: Text('Prioridade ${prioridade.rotulo}'),
                  ),
                  Chip(
                    avatar: Icon(
                      tarefa.concluida ? Icons.check_circle : Icons.schedule,
                      color: tarefa.concluida ? Colors.green : colorScheme.outline,
                      size: 18,
                    ),
                    label: Text(tarefa.situacao),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Data de vencimento'),
                subtitle: Text(tarefa.dataFormatada),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notes),
                title: const Text('Descrição'),
                subtitle: Text(
                  tarefa.descricao.isEmpty ? 'Sem descrição' : tarefa.descricao,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _alternarSituacao(tarefa),
                icon: Icon(tarefa.concluida ? Icons.undo : Icons.check),
                label: Text(
                  tarefa.concluida
                      ? 'Marcar como pendente'
                      : 'Marcar como concluída',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
