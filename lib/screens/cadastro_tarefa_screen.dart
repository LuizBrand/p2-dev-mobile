import 'package:flutter/material.dart';
import '../models/prioridade.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../utils/validadores.dart';

class CadastroTarefaScreen extends StatefulWidget {

  final Tarefa? tarefa;

  const CadastroTarefaScreen({super.key, this.tarefa});

  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _firebaseService = FirebaseService();

  late DateTime _dataVencimento;
  Prioridade _prioridade = Prioridade.media;
  bool _concluida = false;
  bool _salvando = false;

  bool get _editando => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    final tarefa = widget.tarefa;

    if (tarefa != null) {
      _tituloController.text = tarefa.titulo;
      _descricaoController.text = tarefa.descricao;
      _dataVencimento = tarefa.dataVencimento;
      _prioridade = tarefa.prioridade;
      _concluida = tarefa.concluida;
    } else {
      final hoje = DateTime.now();
      _dataVencimento = DateTime(hoje.year, hoje.month, hoje.day);
    }
    _dataController.text = Tarefa.formatarData(_dataVencimento);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _dataVencimento,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (escolhida == null || !mounted) return;

    setState(() {
      _dataVencimento = escolhida;
      _dataController.text = Tarefa.formatarData(escolhida);
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final tarefa = Tarefa(
      id: widget.tarefa?.id,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      dataVencimento: _dataVencimento,
      prioridade: _prioridade,
      concluida: _concluida,
    );
    final mensagem = _editando ? 'Tarefa atualizada!' : 'Tarefa cadastrada!';

    try {
      if (_editando) {
        await _firebaseService.atualizarTarefa(tarefa);
      } else {
        await _firebaseService.adicionarTarefa(tarefa);
      }

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(mensagem)));
    } catch (_) {
      _mostrarErro('Não foi possível salvar a tarefa. Tente novamente.');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: colorScheme.onError)),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _tituloController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (valor) =>
                      Validadores.obrigatorio(valor, 'o título'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dataController,
                  readOnly: true,
                  onTap: _escolherData,
                  decoration: const InputDecoration(
                    labelText: 'Data de vencimento',
                    prefixIcon: Icon(Icons.event),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Prioridade>(
                  initialValue: _prioridade,
                  decoration: const InputDecoration(
                    labelText: 'Prioridade',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: [
                    for (final p in Prioridade.values)
                      DropdownMenuItem(
                        value: p,
                        child: Row(
                          children: [
                            Icon(p.icone, color: p.cor, size: 20),
                            const SizedBox(width: 8),
                            Text(p.rotulo),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (valor) {
                    if (valor != null) setState(() => _prioridade = valor);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<bool>(
                  initialValue: _concluida,
                  decoration: const InputDecoration(
                    labelText: 'Situação',
                    prefixIcon: Icon(Icons.task_alt),
                  ),
                  items: const [
                    DropdownMenuItem(value: false, child: Text('Pendente')),
                    DropdownMenuItem(value: true, child: Text('Concluída')),
                  ],
                  onChanged: (valor) {
                    if (valor != null) setState(() => _concluida = valor);
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(_editando ? 'Salvar alterações' : 'Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}