import 'package:flutter/material.dart';
import '../models/pais.dart';

class PaisCard extends StatelessWidget {
  final Pais pais;
  final VoidCallback onTap;

  const PaisCard({super.key, required this.pais, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (pais.bandeira.isNotEmpty) {
      leadingWidget = Image.network(
        pais.bandeira,
        width: 60,
        height: 40,
        fit: BoxFit.cover,
      );
    } else {
      leadingWidget = Container(
        width: 60,
        height: 40,
        color: Colors.grey[300],
        child: const Icon(Icons.flag, color: Colors.black38),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Card(
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: leadingWidget,
          title: Text(pais.nome),
          onTap: onTap,
        ),
      ),
    );
  }
}
