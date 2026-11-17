// Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.
import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:organizador_leituras/main.dart';
import 'package:organizador_leituras/data/livro_repository.dart';
import 'package:organizador_leituras/models/livro.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Grava, recupera os três status e persiste a remoção', () async {
    final livros = statusLeitura
        .map((s) => Livro(titulo: 'Título $s', autor: 'Autor', status: s))
        .toList();
    await LivroRepository().salvar(livros);
    final recuperados = await LivroRepository().carregar();
    expect(recuperados.map((l) => l.status), statusLeitura);
    expect(recuperados.first.titulo, 'Título Quero ler');
    expect(recuperados.first.autor, 'Autor');
    await LivroRepository().salvar(recuperados..removeAt(0));
    expect(await LivroRepository().carregar(), hasLength(2));
  });

  testWidgets('Valida cadastro, escolhe status, reabre e remove', (
    tester,
  ) async {
    await tester.pumpWidget(const LeiturasApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Adicionar livro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar livro'));
    await tester.pumpAndSettle();
    expect(find.text('Preencha título e autor.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'Dom Casmurro');
    await tester.enterText(find.byType(TextField).at(1), 'Machado de Assis');
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lendo').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar livro'));
    await tester.pumpAndSettle();
    expect(find.text('Dom Casmurro'), findsOneWidget);
    expect(find.text('Machado de Assis • Lendo'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const LeiturasApp());
    await tester.pumpAndSettle();
    expect(find.text('Dom Casmurro'), findsOneWidget);
    await tester.tap(find.byTooltip('Remover livro'));
    await tester.pumpAndSettle();
    expect(find.text('Sua estante está vazia.'), findsOneWidget);
    expect(await LivroRepository().carregar(), isEmpty);
  });

  testWidgets('Dados inválidos não são sobrescritos', (tester) async {
    const invalido = 'json inválido';
    SharedPreferences.setMockInitialValues({LivroRepository.chave: invalido});
    await tester.pumpWidget(const LeiturasApp());
    await tester.pumpAndSettle();
    expect(find.text('Tentar carregar novamente'), findsOneWidget);
    final botao = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(botao.onPressed, isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(LivroRepository.chave), invalido);
  });

  test('Representação JSON preserva caracteres acentuados', () {
    final livro = Livro.fromJson(
      jsonDecode(
        jsonEncode(
          const Livro(
            titulo: 'Memórias',
            autor: 'João',
            status: 'Concluído',
          ).toJson(),
        ),
      ) as Map<String, dynamic>,
    );
    expect(livro.titulo, 'Memórias');
    expect(livro.status, 'Concluído');
  });
}
