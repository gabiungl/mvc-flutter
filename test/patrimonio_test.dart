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

  test('aceita resposta da API em data', () {
    final patrimonio = Patrimonio.fromJson({
      'data': {
        'id': 8,
        'numeroInventario': 'PAT-008',
        'descricao': 'Monitor',
        'local': 'Sala 2',
        'responsavel': 'Bruno',
      },
    });

    expect(patrimonio.id, 8);
    expect(patrimonio.numeroInventario, 'PAT-008');
    expect(patrimonio.descricao, 'Monitor');
  });
}
