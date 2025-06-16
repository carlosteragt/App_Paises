import 'package:flutter/material.dart';
import '../models/pais.dart';
import '../services/pais_service_interface.dart';
import 'tela_detalhes.dart';
import '../widgets/pais_card.dart';

class TelaPaises extends StatefulWidget {
  final IPaisService paisService;

  const TelaPaises({super.key, required this.paisService});

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
      final paises = await widget.paisService.buscarPaises();
      setState(() {
        _todosPaises.addAll(paises);
        _carregando = false;
      });
      _carregarMais();
    } catch (_) {
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
                  return PaisCard(
                    pais: pais,
                    onTap: () => _abrirDetalhes(pais),
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
