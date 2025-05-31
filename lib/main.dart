import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Países',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TelaPaises(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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

class TelaPaises extends StatefulWidget {
  const TelaPaises({super.key});

  @override
  State<TelaPaises> createState() => _TelaPaisesState();
}

class _TelaPaisesState extends State<TelaPaises> {
  final List<Pais> _todosPaises = [];
  final List<Pais> _paisesVisiveis = [];
  final ScrollController _scrollController = ScrollController();
  bool _carregando = true;
  bool _carregandoMais = false;
  int _indiceAtual = 0;
  final int _lote = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_verificaScroll);
    _buscarPaises();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _buscarPaises() async {
    final resposta = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all'),
    );

    if (resposta.statusCode == 200) {
      final List dados = json.decode(resposta.body);
      final paises = dados.map((e) => Pais.fromJson(e)).toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));

      setState(() {
        _todosPaises.addAll(paises);
        _carregando = false;
      });

      _carregarMais();
    } else {
      setState(() => _carregando = false);
    }
  }

  void _verificaScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_carregandoMais &&
        _paisesVisiveis.length < _todosPaises.length) {
      _carregarMais();
    }
  }

  void _carregarMais() {
    if (_carregandoMais || _indiceAtual >= _todosPaises.length) return;

    setState(() => _carregandoMais = true);

    final fim = (_indiceAtual + _lote).clamp(0, _todosPaises.length);
    final novoLote = _todosPaises.sublist(_indiceAtual, fim);

    setState(() {
      _paisesVisiveis.addAll(novoLote);
      _indiceAtual = fim;
      _carregandoMais = false;
    });
  }

  void _abrirDetalhes(Pais pais) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaDetalhes(pais: pais)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Paises')),
      body: _paisesVisiveis.isEmpty
          ? const Center(child: Text('Nenhum país carregado'))
          : ListView.builder(
              controller: _scrollController,
              itemCount: _paisesVisiveis.length + 1,
              itemBuilder: (context, index) {
                if (index < _paisesVisiveis.length) {
                  final pais = _paisesVisiveis[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Image.network(
                          pais.bandeira,
                          width: 60,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(pais.nome),
                        onTap: () => _abrirDetalhes(pais),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: (_paisesVisiveis.length < _todosPaises.length)
                          ? const CircularProgressIndicator()
                          : const Text('Todos os países foram carregados'),
                    ),
                  );
                }
              },
            ),
    );
  }
}

class TelaDetalhes extends StatelessWidget {
  final Pais pais;

  const TelaDetalhes({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pais.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(pais.bandeira, height: 100)),
            const SizedBox(height: 20),
            Text(
              "Capital: ${pais.capital}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Região: ${pais.regiao}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "População: ${pais.populacao}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
