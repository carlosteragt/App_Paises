import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/pais.dart';

class PaisService {
  final String _baseUrl = 'https://restcountries.com/v3.1';

  Future<List<Pais>> listarPaises() async {
    final resposta = await http.get(Uri.parse('$_baseUrl/all'));

    if (resposta.statusCode == 200) {
      final List dados = json.decode(resposta.body);
      return dados.map((e) => Pais.fromJson(e)).toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));
    } else {
      throw Exception('Erro ao carregar países');
    }
  }

  Future<Pais?> buscarPaisPorNome(String nome) async {
    final resposta = await http.get(Uri.parse('$_baseUrl/name/$nome'));

    if (resposta.statusCode == 200) {
      final List dados = json.decode(resposta.body);
      if (dados.isEmpty) return null;
      return Pais.fromJson(dados[0]);
    } else if (resposta.statusCode == 404) {
      return null;
    } else {
      throw Exception('Erro ao buscar país');
    }
  }
}
