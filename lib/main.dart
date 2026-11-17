// Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.
import 'package:material_ui/material_ui.dart';

import 'models/livro.dart';
import 'pages/cadastro_page.dart';
import 'data/livro_repository.dart';

// Substitua pelo mesmo nome completo do comentário acima.
const integrantes = 'Lucas Viana dos Santos e Mariana Alves Carvalho Vieira';

void main() => runApp(const LeiturasApp());

class LeiturasApp extends StatelessWidget {
  const LeiturasApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Minha estante',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    home: const LivrosPage(),
  );
}

class LivrosPage extends StatefulWidget {
  const LivrosPage({super.key});
  @override
  State<LivrosPage> createState() => _LivrosPageState();
}

class _LivrosPageState extends State<LivrosPage> {
  List<Livro> _livros = [];
  final _repository = LivroRepository();
  bool _ocupado = true;
  bool _erroCarga = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _mensagem(String texto) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(texto)));

  Future<void> _carregar() async {
    setState(() {
      _ocupado = true;
      _erroCarga = false;
    });
    try {
      final livros = await _repository.carregar();
      if (!mounted) return;
      setState(() => _livros = livros);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erroCarga = true);
      _mensagem('Não foi possível carregar os livros. Tente novamente.');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _atualizar(List<Livro> livros, String mensagem) async {
    setState(() => _ocupado = true);
    try {
      await _repository.salvar(livros);
      if (!mounted) return;
      setState(() => _livros = livros);
      _mensagem(mensagem);
    } catch (_) {
      if (mounted) _mensagem('Falha ao salvar. Tente novamente.');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _cadastrar() async {
    final livro = await Navigator.push<Livro>(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastroPage(integrantes: integrantes),
      ),
    );
    if (!mounted || livro == null) return;
    await _atualizar([..._livros, livro], 'Livro adicionado!');
  }

  Future<void> _remover(int indice) async {
    final livros = [..._livros]..removeAt(indice);
    await _atualizar(livros, 'Livro removido!');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 108,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Minha estante'),
          Text(integrantes, maxLines: 3, style: TextStyle(fontSize: 13)),
        ],
      ),
    ),
    body: _ocupado
        ? const Center(child: CircularProgressIndicator())
        : _erroCarga
        ? Center(
            child: FilledButton(
              onPressed: _carregar,
              child: const Text('Tentar carregar novamente'),
            ),
          )
        : _livros.isEmpty
        ? const Center(child: Text('Sua estante está vazia.'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _livros.length,
            itemBuilder: (context, index) {
              final livro = _livros[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(livro.titulo),
                  subtitle: Text('${livro.autor} • ${livro.status}'),
                  trailing: IconButton(
                    tooltip: 'Remover livro',
                    onPressed: _ocupado ? null : () => _remover(index),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: _ocupado || _erroCarga ? null : _cadastrar,
      tooltip: 'Adicionar livro',
      child: const Icon(Icons.add),
    ),
  );
}
