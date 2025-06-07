import 'package:flutter/material.dart';
import 'services/pais_service.dart';
import 'models/pais.dart';
import 'telas/tela_detalhes.dart';

void main() {
  runApp(const MeuApp());
}

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
      home: TelaPaises(service: PaisService()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaPaises extends StatefulWidget {
  final PaisService service;

  const TelaPaises({super.key, required this.service});

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
    try {
      final paises = await widget.service.listarPaises();
      paises.sort((a, b) => a.nome.compareTo(b.nome));
      setState(() {
        _todosPaises.addAll(paises);
        _carregando = false;
      });
      _carregarMais();
    } catch (e) {
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
      appBar: AppBar(title: const Text('Lista de Países')),
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
                        vertical: 12, horizontal: 16),
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