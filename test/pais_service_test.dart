import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lazy_loading/services/pais_service.dart';
import 'package:lazy_loading/models/pais.dart';

import 'pais_service_test.mocks.dart';

@GenerateMocks([PaisService])
void main() {
  late MockPaisService mockService;

  setUp(() {
    mockService = MockPaisService();
  });

  group('PaisService Tests', () {
    final paisExemplo = Pais(
      nome: 'Brasil',
      bandeira: 'https://flagcdn.com/w320/br.png',
      capital: 'Brasília',
      regiao: 'Américas',
      populacao: 211000000,
    );

    /// Cenário 01
    test('Listagem de países com sucesso', () async {
      when(mockService.listarPaises()).thenAnswer((_) async => [paisExemplo]);

      final resultado = await mockService.listarPaises();

      expect(resultado, isNotEmpty);
      expect(resultado.first.nome, equals('Brasil'));
      expect(resultado.first.capital, equals('Brasília'));
      expect(resultado.first.bandeira, contains('br.png'));
    });

    /// Cenário 02
    test('Erro ao listar países', () async {
      when(mockService.listarPaises()).thenThrow(Exception('Erro na API'));

      expect(() => mockService.listarPaises(), throwsException);
    });
  });
}
