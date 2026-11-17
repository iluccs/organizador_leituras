// Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.
import 'package:material_ui/material_ui.dart';

import '../models/livro.dart';

class CadastroPage extends StatefulWidget {
  final String integrantes;
  const CadastroPage({super.key, required this.integrantes});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _titulo = TextEditingController();
  final _autor = TextEditingController();
  String _status = statusLeitura.first;

  @override
  void dispose() {
    _titulo.dispose();
    _autor.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_titulo.text.trim().isEmpty || _autor.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha título e autor.')));
      return;
    }
    Navigator.pop(
      context,
      Livro(
        titulo: _titulo.text.trim(),
        autor: _autor.text.trim(),
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 108,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cadastrar livro'),
          Text(widget.integrantes, maxLines: 3, style: const TextStyle(fontSize: 13)),
        ],
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titulo,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _autor,
            decoration: const InputDecoration(
              labelText: 'Autor',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          const Text('Status da leitura'),
          DropdownButton<String>(
            value: _status,
            isExpanded: true,
            items: statusLeitura
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _status = value);
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _salvar,
            icon: const Icon(Icons.check),
            label: const Text('Salvar livro'),
          ),
        ],
      ),
    ),
  );
}
