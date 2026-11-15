import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../widgets/drawer_menu.dart';
import 'configuracoes_screen.dart';
import 'tarefas_screen.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;

  const HomeScreen({super.key, required this.usuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<List<Tarefa>> _tarefasStream = FirebaseService().tarefasStream();

  void _abrir(Widget tela) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final saudacao =
    usuario.nome.isEmpty ? 'Olá!' : 'Olá, ${usuario.nome}!';

    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: DrawerMenu(usuario: usuario),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(saudacao, style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Bem-vindo ao gerenciador de tarefas.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text('Resumo das tarefas', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          StreamBuilder<List<Tarefa>>(
            stream: _tarefasStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Não foi possível carregar o resumo.');
                }
                    if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final tarefas = snapshot.data!;
                final concluidas = tarefas.where((t) => t.concluida).length;
                final pendentes = tarefas.length - concluidas;

                return Row(
                  children: [
                    Expanded(
                      child: _ContadorCard(
                        rotulo: 'Total',
                        valor: tarefas.length,
                        icone: Icons.list_alt,
                        cor: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ContadorCard(
                        rotulo: 'Pendentes',
                        valor: pendentes,
                        icone: Icons.schedule,
                        cor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ContadorCard(
                        rotulo: 'Concluídas',
                        valor: concluidas,
                        icone: Icons.check_circle,
                        cor: Colors.green,
                      ),
                    ),
                  ],
                );
              },
          ),
          const SizedBox(height: 24),
          _AtalhoCard(
            icone: Icons.checklist,
            titulo: 'Minhas tarefas',
            subtitulo: 'Ver, cadastrar e editar suas tarefas',
            onTap: () => _abrir(const TarefasScreen()),
          ),
          _AtalhoCard(
            icone: Icons.settings_outlined,
            titulo: 'Configurações',
            subtitulo: 'Tema claro ou escuro',
            onTap: () => _abrir(const ConfiguracoesScreen()),
          ),
        ],
      ),
    );
  }
}

class _AtalhoCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _AtalhoCard({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icone, color: Theme.of(context).colorScheme.primary),
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _ContadorCard extends StatelessWidget {
  final String rotulo;
  final int valor;
  final IconData icone;
  final Color cor;

  const _ContadorCard({
    required this.rotulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icone, color: cor),
            const SizedBox(height: 8),
            Text(
              '$valor',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(rotulo, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}