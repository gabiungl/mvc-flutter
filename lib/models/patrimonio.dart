class Patrimonio {
  const Patrimonio({
    required this.id,
    required this.numeroInventario,
    required this.descricao,
    required this.local,
    required this.responsavel,
  });

  final dynamic id;
  final String numeroInventario;
  final String descricao;
  final String local;
  final String responsavel;

  factory Patrimonio.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapPayload(json);

    return Patrimonio(
      id: _first(payload, ['id', 'codigo', '_id', 'patrimonio_id', 'patrimonioId']),
      numeroInventario: _text(payload, [
        'n_do_inventario',
        'numero_inventario',
        'numeroInventario',
        'inventario',
        'numeroInventarioPatrimonio',
      ]),
      descricao: _text(payload, ['descricao', 'description']),
      local: _text(payload, ['local', 'localizacao', 'location']),
      responsavel: _text(payload, ['responsavel', 'responsible', 'usuario']),
    );
  }

  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> json) {
    final candidates = [json['data'], json['patrimonio'], json['item'], json['result']];
    for (final candidate in candidates) {
      if (candidate is Map) {
        return Map<String, dynamic>.from(candidate);
      }
    }
    return json;
  }

  static dynamic _first(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value != null) return value;
    }
    return null;
  }

  static bool fromJsonMapLooksLikePatrimonio(Map<dynamic, dynamic> map) {
    return map.containsKey('id') ||
        map.containsKey('codigo') ||
        map.containsKey('_id') ||
        map.containsKey('n_do_inventario') ||
        map.containsKey('numero_inventario') ||
        map.containsKey('numeroInventario') ||
        map.containsKey('descricao');
  }

  Map<String, dynamic> toJson() {
    return {
      'n_do_inventario': numeroInventario,
      'descricao': descricao,
      'local': local,
      'responsavel': responsavel,
    };
  }


  static String _text(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return '';
  }
}
