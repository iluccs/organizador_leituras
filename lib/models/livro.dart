// Integrantes: Lucas Viana dos Santos e Mariana Alves Carvalho Vieira.
class Livro {
  final String titulo;
  final String autor;
  final String status;

  const Livro({
    required this.titulo,
    required this.autor,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'autor': autor,
    'status': status,
  };

  factory Livro.fromJson(Map<String, dynamic> json) {
    final titulo = json['titulo'];
    final autor = json['autor'];
    final status = json['status'];
    if (titulo is! String ||
        autor is! String ||
        status is! String ||
        titulo.trim().isEmpty ||
        autor.trim().isEmpty ||
        !statusLeitura.contains(status)) {
      throw const FormatException('Livro inválido.');
    }
    return Livro(titulo: titulo, autor: autor, status: status);
  }
}

const statusLeitura = ['Quero ler', 'Lendo', 'Concluído'];
