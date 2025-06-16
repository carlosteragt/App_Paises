import '../models/pais.dart';

abstract class IPaisService {
  Future<List<Pais>> buscarPaises();
}
