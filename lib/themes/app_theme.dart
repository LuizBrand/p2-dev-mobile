import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _corBase = Colors.indigo;
  static final ThemeData lightTheme = _criarTema(Brightness.light);
  static final ThemeData darkTheme = _criarTema(Brightness.dark);

  static ThemeData _criarTema(Brightness brilho) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _corBase,
      brightness: brilho,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}