import 'package:flutter/material.dart';
import 'screens/tela_paises.dart';
import 'services/pais_service.dart';

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
      home: TelaPaises(paisService: PaisService()),
      debugShowCheckedModeBanner: false,
    );
  }
}
