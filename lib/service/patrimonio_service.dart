
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mvc/model/patrimonio_model.dart';

class PatrimonioService {

  // Endereço da API
  final String baseUrl = 'http://localhost:8080';

  // 1. LISTAR PATRIMÔNIOS
  // GET /api/v1/patrimonios

  Future<List<Patrimonio>> listarPatrimonios() async {

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/patrimonios'),
    );

    if (response.statusCode == 200) {

      final List dados = jsonDecode(response.body);

      return dados.map(
        (item) => Patrimonio.fromJson(item),
      ).toList();

    } else {

      throw Exception(
        'Erro ao buscar patrimônios',
      );
    }
  }


  // 2. PESQUISAR
  // GET /api/v1/patrimonios?q=termo

  Future<List<Patrimonio>> pesquisarPatrimonios(
    String termo,
  ) async {

    final uri = Uri.parse(
      '$baseUrl/api/v1/patrimonios',
    ).replace(
      queryParameters: {
        'q': termo,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {

      final List dados = jsonDecode(response.body);

      return dados.map(
        (item) => Patrimonio.fromJson(item),
      ).toList();

    } else {

      throw Exception(
        'Erro ao pesquisar patrimônios',
      );
    }
  }


  // 3. BUSCAR POR ID
  // GET /api/v1/patrimonios/{id}

  Future<Patrimonio> buscarPorId(
    int id,
  ) async {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/v1/patrimonios/$id',
      ),
    );

    if (response.statusCode == 200) {

      final dados = jsonDecode(response.body);

      return Patrimonio.fromJson(dados);

    } else {

      throw Exception(
        'Erro ao buscar patrimônio',
      );
    }
  }


  // 4. CADASTRAR
  // POST /api/v1/patrimonios

  Future<Patrimonio> cadastrar(
    Patrimonio patrimonio,
  ) async {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/api/v1/patrimonios',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(
        patrimonio.toJson(),
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      final dados = jsonDecode(response.body);

      return Patrimonio.fromJson(dados);

    } else {

      throw Exception(
        'Erro ao cadastrar patrimônio',
      );
    }
  }


  // 5. EDITAR
  // PUT /api/v1/patrimonios/{id}

  Future<Patrimonio> editar(
    int id,
    Patrimonio patrimonio,
  ) async {

    final response = await http.put(

      Uri.parse(
        '$baseUrl/api/v1/patrimonios/$id',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(
        patrimonio.toJson(),
      ),
    );

    if (response.statusCode == 200) {

      final dados = jsonDecode(response.body);

      return Patrimonio.fromJson(dados);

    } else {

      throw Exception(
        'Erro ao editar patrimônio',
      );
    }
  }


  // 6. EXCLUIR
  // DELETE /api/v1/patrimonios/{id}

  Future<void> excluir(
    int id,
  ) async {

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/api/v1/patrimonios/$id',
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {

      throw Exception(
        'Erro ao excluir patrimônio',
      );
    }
  }
}