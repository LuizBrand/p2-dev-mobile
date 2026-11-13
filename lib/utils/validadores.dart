class Validadores {
  Validadores._();

  static String? obrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo';
    }
    return null;
  }

  static String? email(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail';
    }
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(valor.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? senha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe a senha';
    }
    if (valor.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}