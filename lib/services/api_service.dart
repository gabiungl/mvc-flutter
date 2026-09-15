import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/patrimonio.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';
  static const String resource = '/api/v1/patrimonios';

  Future<List<Patrimonio>> listar({String? pesquisa}) async {
    final query = pesquisa == null || pesquisa.trim().isEmpty
        ? <String, String>{}
        : {'q': pesquisa.trim()};
    final response = await http.get(_uri(resource, query));
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body);
    final values = decoded is List
        ? decoded
        : (decoded['items'] ?? decoded['data'] ?? decoded['patrimonios'] ?? []);
    return (values as List)
        .map((item) => Patrimonio.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Patrimonio> buscarPorId(dynamic id) async {
    final response = await http.get(_uri('$resource/$id'));
    _ensureSuccess(response);
    return Patrimonio.fromJson(Map<String, dynamic>.from(jsonDecode(response.body)));
  }

  Future<Patrimonio> criar(Patrimonio patrimonio) async {
    final response = await http.post(
      _uri(resource),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patrimonio.toJson()),
    );
    _ensureSuccess(response);
    return Patrimonio.fromJson(Map<String, dynamic>.from(jsonDecode(response.body)));
  }

  Future<Patrimonio> atualizar(dynamic id, Patrimonio patrimonio) async {
    final response = await http.put(
      _uri('$resource/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patrimonio.toJson()),
    );
    _ensureSuccess(response);
    return Patrimonio.fromJson(Map<String, dynamic>.from(jsonDecode(response.body)));
  }

  Future<void> excluir(dynamic id) async {
    final response = await http.delete(_uri('$resource/$id'));
    _ensureSuccess(response);
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: query);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }
}
