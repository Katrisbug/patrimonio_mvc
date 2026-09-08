class Patrimonio {
  final int id;
  final String numeroInventario;
  final String descricao;
  final String local;
  final String responsavel;
  final DateTime dataRegistro;

  Patrimonio({
    required this.id,
    required this.numeroInventario,
    required this.descricao,
    required this.local,
    required this.responsavel, 
    required this.dataRegistro,
  });

  factory Patrimonio.fromJson(Map<String, dynamic> json){
    return Patrimonio(
      id: json['id'],
      numeroInventario: json['numero_inventario'],
      descricao: json['descricao'],
      local: json['local'],
      responsavel: json['responsavel'], 
      dataRegistro: DateTime.parse(json['data_registro']
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'id': id,
      'numero_inventario': numeroInventario,
      'descricao': descricao,
      'local': local,
      'responsavel': responsavel,
      'data_registro': dataRegistro.toIso8601String(),
    };
  }
}