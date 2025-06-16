import 'package:flutter/material.dart';
import '../models/pais.dart';

class TelaDetalhes extends StatelessWidget {
  final Pais pais;

  const TelaDetalhes({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (pais.bandeira.isNotEmpty) {
      imageWidget = Image.network(pais.bandeira, height: 100);
    } else {
      imageWidget = Container(
        height: 100,
        width: 160,
        color: Colors.grey[300],
        child: const Icon(Icons.flag, size: 40, color: Colors.black38),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(pais.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: imageWidget),
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
