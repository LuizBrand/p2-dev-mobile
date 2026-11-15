import 'package:flutter/material.dart';
import '../themes/theme_controller.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Aparência',
              style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
            ),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeMode,
            builder: (context, modo, _) {
              final escuro = modo == ThemeMode.dark;
              return SwitchListTile(
                secondary: Icon(escuro ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Tema escuro'),
                subtitle: const Text('A escolha fica salva no aparelho'),
                value: escuro,
                onChanged: ThemeController.definirTemaEscuro,
              );
            },
          ),
        ],
      ),
    );
  }
}