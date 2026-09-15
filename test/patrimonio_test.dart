import 'package:flutter_test/flutter_test.dart';

import 'package:patrimonio_senai/models/patrimonio.dart';
import 'package:patrimonio_senai/services/api_service.dart';

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

  test('parseia resposta de listagem quando data vem como objeto único', () {
    final lista = ApiService.parseLista({
      'data': {
        'id': 9,
        'n_do_inventario': 'PAT-009',
        'descricao': 'Teclado',
        'local': 'Sala 3',
        'responsavel': 'Carla',
      },
    });

    expect(lista, hasLength(1));
    expect(lista.first.id, 9);
    expect(lista.first.numeroInventario, 'PAT-009');
  });
}
