import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_paises/models/pais.dart';
import 'package:app_paises/services/pais_service_interface.dart';

import 'pais_service_test.mocks.dart';

@GenerateMocks([IPaisService])
void main() {
  late MockIPaisService mockPaisService;

  setUp(() {
    mockPaisService = MockIPaisService();
  });

  test('Cenário 01 - Listagem bem-sucedida', () async {
    final pais = Pais(
      nome: 'Afghanistan',
      bandeira:
          '', //deixei as bandeiras vazias porque estava dando erro ao passar o link
      capital: 'Kabul',
      regiao: 'Asia',
      populacao: 40218234,
    );

    when(mockPaisService.buscarPaises()).thenAnswer((_) async => [pais]);

    final resultado = await mockPaisService.buscarPaises();

    expect(resultado, isNotEmpty);
    expect(resultado.first.nome, equals('Afghanistan'));
    expect(resultado.first.capital, equals('Kabul'));
    expect(resultado.first.regiao, equals('Asia'));

    verify(mockPaisService.buscarPaises()).called(1);
  });

  test('Cenário 02 - Erro na requisição', () async {
    when(mockPaisService.buscarPaises()).thenThrow(Exception('Erro API'));

    expect(() async => await mockPaisService.buscarPaises(), throwsException);

    verify(mockPaisService.buscarPaises()).called(1);
  });

  test('Cenário 03 - Busca de país por nome com resultado', () async {
    final pais = Pais(
      nome: 'Japan',
      bandeira: '',
      capital: 'Tokyo',
      regiao: 'Asia',
      populacao: 125836021,
    );

    when(mockPaisService.buscarPaises()).thenAnswer((_) async => [pais]);

    final lista = await mockPaisService.buscarPaises();
    final resultado = lista.firstWhere(
      (p) => p.nome == 'Japan',
      orElse: () => throw Exception('Não encontrado'),
    );

    expect(resultado, isNotNull);
    expect(resultado.capital, equals('Tokyo'));
  });

  test('Cenário 04 - Busca de país por nome com resultado vazio', () async {
    when(mockPaisService.buscarPaises()).thenAnswer((_) async => []);

    final lista = await mockPaisService.buscarPaises();

    expect(
      () => lista.firstWhere((p) => p.nome == 'Atlantis'),
      throwsException,
    );
  });

  test('Cenário 05 - País com dados incompletos', () async {
    final pais = Pais(
      nome: 'País Desconhecido',
      bandeira: '',
      capital: '',
      regiao: 'N/A',
      populacao: 0,
    );

    when(mockPaisService.buscarPaises()).thenAnswer((_) async => [pais]);

    final resultado = await mockPaisService.buscarPaises();

    expect(resultado.first.bandeira, isEmpty);
    expect(resultado.first.capital, isEmpty);
  });

  test('Cenário 06 - Verificar chamada ao método listarPaises()', () async {
    when(mockPaisService.buscarPaises()).thenAnswer((_) async => []);

    await mockPaisService.buscarPaises();

    verify(mockPaisService.buscarPaises()).called(1);
  });
}
