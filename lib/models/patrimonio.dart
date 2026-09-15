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
    final payload = json['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return Patrimonio(
      id: payload['id'] ?? payload['codigo'] ?? payload['_id'],
      numeroInventario: _text(payload, [
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

  Map<String, dynamic> toJson() {
    return {
      'numero_inventario': numeroInventario,
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
