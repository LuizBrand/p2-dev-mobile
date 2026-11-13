import 'package:flutter/material.dart';

enum Prioridade {
  baixa('Baixa', Colors.green, Icons.arrow_downward),
  media('Média', Colors.orange, Icons.remove),
  alta('Alta', Colors.red, Icons.priority_high);

  const Prioridade(this.rotulo, this.cor, this.icone);

  final String rotulo;
  final Color cor;
  final IconData icone;

  static Prioridade fromNome(String? nome) {
    return Prioridade.values.asNameMap()[nome] ?? Prioridade.media;
  }
}