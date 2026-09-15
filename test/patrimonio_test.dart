import 'package:flutter_test/flutter_test.dart';

import 'package:patrimonio_senai/models/patrimonio.dart';

void main() {
  test('converte patrimonio entre JSON e modelo', () {
    final patrimonio = Patrimonio.fromJson({
      'id': 7,
      'numero_inventario': 'PAT-007',
      'descricao': 'Notebook',
      'local': 'Laboratório 1',
      'responsavel': 'Ana',
    });

    expect(patrimonio.id, 7);
    expect(patrimonio.numeroInventario, 'PAT-007');
    expect(patrimonio.toJson()['descricao'], 'Notebook');
  });
}
