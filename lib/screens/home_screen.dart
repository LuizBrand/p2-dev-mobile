import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final Usuario usuario;

  const HomeScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Olá, ${usuario.nome}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}