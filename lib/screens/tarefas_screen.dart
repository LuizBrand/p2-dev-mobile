import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import 'cadastro_tarefa_screen.dart';
import 'detalhe_tarefa_screen.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final Stream<List<Tarefa>> _tarefasStream = FirebaseService().tarefasStream();

  void _abrir(Widget tela) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrir(const CadastroTarefaScreen()),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
      body: StreamBuilder<List<Tarefa>>(
        stream: _tarefasStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível carregar as tarefas.'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tarefas = snapshot.data!;
          if (tarefas.isEmpty) {
            return const _ListaVazia();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              return _TarefaItem(
                tarefa: tarefa,
                onTap: () => _abrir(DetalheTarefaScreen(tarefa: tarefa)),
              );
            },
          );
        },
      ),
    );
  }
}

class _TarefaItem extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback onTap;

  const _TarefaItem({required this.tarefa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final prioridade = tarefa.prioridade;

    return Card(
      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        titleAlignment: ListTileTitleAlignment.center,
        leading: CircleAvatar(
          backgroundColor: prioridade.cor.withValues(alpha: 0.15),
          foregroundColor: prioridade.cor,
          child: Icon(prioridade.icone),
        ),
        title: Text(
          tarefa.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tarefa.concluida
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          'Vence em ${tarefa.dataFormatada}\n'
              'Prioridade ${prioridade.rotulo}',
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tarefa.concluida ? Icons.check_circle : Icons.schedule,
              color: tarefa.concluida ? Colors.green : colorScheme.outline,
            ),
            Text(tarefa.situacao, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _ListaVazia extends StatelessWidget {
  const _ListaVazia();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('Nenhuma tarefa cadastrada', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Toque em "Nova tarefa" para começar.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}