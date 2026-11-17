// Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.
import 'package:material_ui/material_ui.dart';

import 'models/livro.dart';

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
  final List<Livro> _livros = [];

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
    body: _livros.isEmpty
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
                ),
              );
            },
          ),
  );
}
