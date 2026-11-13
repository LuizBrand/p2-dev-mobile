import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static final PreferencesService _preferences = PreferencesService();
  static bool get temaEscuro => themeMode.value == ThemeMode.dark;

  static Future<void> carregar() async {
    final escuro = await _preferences.carregarTemaEscuro();
    themeMode.value = escuro ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> definirTemaEscuro(bool escuro) async {
    themeMode.value = escuro ? ThemeMode.dark : ThemeMode.light;
    await _preferences.salvarTemaEscuro(escuro);
  }
}