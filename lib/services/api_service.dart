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
    return parseLista(decoded);
  }

  static List<Patrimonio> parseLista(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((item) => Patrimonio.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (decoded is Map) {
      final candidates = [
        decoded['items'],
        decoded['data'],
        decoded['patrimonios'],
        decoded['result'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate
              .whereType<Map>()
              .map((item) => Patrimonio.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
        if (candidate is Map) {
          final parsed = parseLista(candidate);
          if (parsed.isNotEmpty) {
            return parsed;
          }
        }
      }

      if (Patrimonio.fromJsonMapLooksLikePatrimonio(decoded)) {
        return [Patrimonio.fromJson(Map<String, dynamic>.from(decoded))];
      }
    }

    return const [];
  }

  Future<Patrimonio> buscarPorId(dynamic id) async {
    if (id == null || id.toString().trim().isEmpty) {
      throw Exception('Identificador do patrimônio não informado');
    }

    final response = await http.get(_uri('$resource/$id'));
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body);
    final payload = decoded is Map ? decoded : {'data': decoded};
    final data = payload['data'] is Map ? payload['data'] : payload;
    return Patrimonio.fromJson(Map<String, dynamic>.from(data));
  }

  Future<Patrimonio> criar(Patrimonio patrimonio) async {
    final response = await http.post(
      _uri(resource),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patrimonio.toJson()),
    );
    _ensureSuccess(response);
    return Patrimonio.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.body)));
  }

  Future<Patrimonio> atualizar(dynamic id, Patrimonio patrimonio) async {
    final response = await http.put(
      _uri('$resource/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patrimonio.toJson()),
    );
    _ensureSuccess(response);
    return Patrimonio.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.body)));
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
