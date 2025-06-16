class Pais {
  final String nome;
  final String bandeira;
  final String capital;
  final String regiao;
  final int populacao;

  Pais({
    required this.nome,
    required this.bandeira,
    required this.capital,
    required this.regiao,
    required this.populacao,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      nome: json['name']['common'] ?? '',
      bandeira: json['flags']['png'] ?? '',
      capital: (json['capital'] != null && json['capital'].isNotEmpty)
          ? json['capital'][0]
          : 'N/A',
      regiao: json['region'] ?? 'N/A',
      populacao: json['population'] ?? 0,
    );
  }
}
