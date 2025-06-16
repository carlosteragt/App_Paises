import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_paises/models/pais.dart';
import 'package:app_paises/screens/tela_paises.dart';
import 'package:app_paises/services/pais_service_interface.dart';

import 'tela_paises_test.mocks.dart';

@GenerateMocks([IPaisService])
void main() {
  late MockIPaisService mockPaisService;

  setUp(() {
    mockPaisService = MockIPaisService();
  });

  testWidgets('Cenário 01 - Verificar se o nome do país aparece na lista', (
    WidgetTester tester,
  ) async {
    final pais = Pais(
      nome: 'Japan',
      bandeira: '',
      capital: 'Tokyo',
      regiao: 'Asia',
      populacao: 125836021,
    );

    when(mockPaisService.buscarPaises()).thenAnswer((_) async => [pais]);

    await tester.pumpWidget(
      MaterialApp(home: TelaPaises(paisService: mockPaisService)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Japan'), findsOneWidget);
  });

  testWidgets('Cenário 02 - Verificar se ao clicar em um país abre detalhes', (
    WidgetTester tester,
  ) async {
    final pais = Pais(
      nome: 'Japan',
      bandeira: '',
      capital: 'Tokyo',
      regiao: 'Asia',
      populacao: 125836021,
    );

    when(mockPaisService.buscarPaises()).thenAnswer((_) async => [pais]);

    await tester.pumpWidget(
      MaterialApp(home: TelaPaises(paisService: mockPaisService)),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Japan'));
    await tester.pumpAndSettle();

    expect(find.text('Japan'), findsWidgets);
    expect(find.text('Capital: Tokyo'), findsOneWidget);
  });

  //Não consegui fazer o cenario 3
}
