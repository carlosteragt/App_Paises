import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pais.dart';
import 'pais_service_interface.dart';

class PaisService implements IPaisService {
  static const String _url =
      'https://restcountries.com/v3.1/all?fields=name,flags,capital,region,population';

  @override
  Future<List<Pais>> buscarPaises() async {
    final resposta = await http.get(Uri.parse(_url));

    if (resposta.statusCode == 200) {
      final List dados = json.decode(resposta.body);
      final paises = dados.map((e) => Pais.fromJson(e)).toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));
      return paises;
    } else {
      throw Exception('Erro ao buscar países');
    }
  }
}
