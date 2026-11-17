# TP7 — Organização de Leituras — parte 3

Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.

Requer Flutter estável (Dart >= 3.14). Plataformas geradas: Android e Web.

```sh
flutter pub get
flutter analyze
flutter run
```

O histórico Git registra três etapas: estrutura e listagem; cadastro e remoção; persistência e testes.

## Persistência
A coleção é convertida com jsonEncode para uma String na chave livros_v1.
Na inicialização, initState chama carregar, que usa jsonDecode e reconstrói
os objetos Livro. SharedPreferences aceita valores simples, não objetos Dart.
Não há SQLite ou banco externo. A gravação é aguardada antes da confirmação;
falhas de leitura bloqueiam alterações para não sobrescrever dados existentes.
É adequado a uma lista pequena; não oferece consultas ou transações de um banco.
Desinstalar o app ou limpar seus dados remove as preferências. Na Web, mantenha
navegador e origem (incluindo porta) para recuperar os mesmos dados.

## Testar
```sh
flutter test
```
Teste também no dispositivo: cadastre livros nos três status, remova um,
feche e reabra o aplicativo e confira os livros restantes. Teste campos vazios
(incluindo somente espaços), voltar sem salvar e títulos repetidos.

## Referências
- https://pub.dev/packages/shared_preferences
- https://docs.flutter.dev/cookbook/navigation/navigation-basics
