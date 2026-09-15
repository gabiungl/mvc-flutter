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
    return Patrimonio(
      id: json['id'] ?? json['codigo'] ?? json['_id'],
      numeroInventario: _text(json, ['numero_inventario', 'numeroInventario', 'inventario']),
      descricao: _text(json, ['descricao', 'description']),
      local: _text(json, ['local', 'localizacao', 'location']),
      responsavel: _text(json, ['responsavel', 'responsible']),
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
