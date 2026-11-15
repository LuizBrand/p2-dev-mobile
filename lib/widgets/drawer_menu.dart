import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../screens/configuracoes_screen.dart';
import '../screens/tarefas_screen.dart';
import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  final Usuario usuario;

  const DrawerMenu({super.key, required this.usuario});

  void _abrirTela(BuildContext context, Widget tela) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute(builder: (_) => tela));
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o aplicativo'),
        content: const Text(
          'Minhas Tarefas – versão 1.0.0\n\n'
              'Aplicativo de gerenciamento de tarefas pessoais desenvolvido '
              'para a P2 de Programação Mobile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _sair(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      await AuthService().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inicial =
    usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : '?';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.onPrimary,
              foregroundColor: colorScheme.primary,
              child: Text(inicial, style: const TextStyle(fontSize: 32)),
            ),
            accountName: Text(
              usuario.nome,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              usuario.email,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Início'),
            selected: true,
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Minhas tarefas'),
            onTap: () => _abrirTela(context, const TarefasScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            onTap: () => _abrirTela(context, const ConfiguracoesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o aplicativo'),
            onTap: () => _mostrarSobre(context),
          ),
          const Spacer(),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text('Sair', style: TextStyle(color: colorScheme.error)),
              onTap: () => _sair(context),
            ),
          ),
        ],
      ),
    );
  }
}