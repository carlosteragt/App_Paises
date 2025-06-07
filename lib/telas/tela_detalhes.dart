import 'package:flutter/material.dart';
import '../models/pais.dart';

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
            Text("Capital: ${pais.capital}", style: const TextStyle(fontSize: 18)),
            Text("Região: ${pais.regiao}", style: const TextStyle(fontSize: 18)),
            Text("População: ${pais.populacao}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}