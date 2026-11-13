import 'prioridade.dart';

class Tarefa {
  final String? id;
  final String titulo;
  final String descricao;
  final DateTime dataVencimento;
  final Prioridade prioridade;
  final bool concluida;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    this.concluida = false,
  });

  String get situacao => concluida ? 'Concluída' : 'Pendente';

  String get dataFormatada {
    final dia = dataVencimento.day.toString().padLeft(2, '0');
    final mes = dataVencimento.month.toString().padLeft(2, '0');
    return '$dia/$mes/${dataVencimento.year}';
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.toIso8601String(),
      'prioridade': prioridade.name,
      'concluida': concluida,
    };
  }

  factory Tarefa.fromMap(String id, Map<dynamic, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      dataVencimento:
      DateTime.tryParse(map['dataVencimento'] as String? ?? '') ??
          DateTime.now(),
      prioridade: Prioridade.fromNome(map['prioridade'] as String?),
      concluida: map['concluida'] as bool? ?? false,
    );
  }

  /*Usado na edição e ao alternar pendente-concluída.*/
  Tarefa copyWith({
    String? id,
    String? titulo,
    String? descricao,
    DateTime? dataVencimento,
    Prioridade? prioridade,
    bool? concluida,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      prioridade: prioridade ?? this.prioridade,
      concluida: concluida ?? this.concluida,
    );
  }
}