// Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/livro.dart';

class LivroRepository {
  static const chave = 'livros_v1';

  Future<List<Livro>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(chave);
    if (texto == null) return [];
    final dados = jsonDecode(texto);
    if (dados is! List) {
      throw const FormatException('Lista de livros inválida.');
    }
    return dados
        .map((item) => Livro.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> salvar(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences não armazena objetos: a coleção vira uma String JSON.
    final sucesso = await prefs.setString(
      chave,
      jsonEncode(livros.map((livro) => livro.toJson()).toList()),
    );
    if (!sucesso) throw Exception('Não foi possível salvar os livros.');
  }
}
