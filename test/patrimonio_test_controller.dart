import 'package:flutter_test/flutter_test.dart';

import 'package:mvc/controller/patrimonio_controller.dart';
import 'package:mvc/model/patrimonio_model.dart';
import 'package:mvc/service/patrimonio_service.dart';


// ========================================
// SERVICE FALSO PARA OS TESTES
// ========================================

class FakePatrimonioService
    extends PatrimonioService {

  List<Patrimonio> lista = [

    Patrimonio(
      id: 1,
      numeroInventario: 'PAT001',
      descricao: 'Computador Dell',
      local: 'Laboratório 1',
      responsavel: 'João',
      dataRegistro:
          DateTime(2026, 9, 8),
    ),

    Patrimonio(
      id: 2,
      numeroInventario: 'PAT002',
      descricao: 'Projetor Epson',
      local: 'Sala 2',
      responsavel: 'Maria',
      dataRegistro:
          DateTime(2026, 9, 8),
    ),
  ];


  @override
  Future<List<Patrimonio>>
      listarPatrimonios() async {

    return lista;
  }


  @override
  Future<List<Patrimonio>>
      pesquisarPatrimonios(
    String termo,
  ) async {

    return lista.where((patrimonio) {

      return patrimonio.descricao
              .toLowerCase()
              .contains(
                termo.toLowerCase(),
              ) ||

          patrimonio.numeroInventario
              .toLowerCase()
              .contains(
                termo.toLowerCase(),
              );

    }).toList();
  }


  @override
  Future<Patrimonio>
      buscarPorId(int id) async {

    return lista.firstWhere(
      (item) => item.id == id,
    );
  }


  @override
  Future<Patrimonio>
      cadastrar(
    Patrimonio patrimonio,
  ) async {

    final novo = Patrimonio(
      id: 3,
      numeroInventario:
          patrimonio.numeroInventario,
      descricao:
          patrimonio.descricao,
      local:
          patrimonio.local,
      responsavel:
          patrimonio.responsavel,
      dataRegistro:
          patrimonio.dataRegistro,
    );

    lista.add(novo);

    return novo;
  }


  @override
  Future<Patrimonio>
      editar(
    int id,
    Patrimonio patrimonio,
  ) async {

    final atualizado = Patrimonio(
      id: id,
      numeroInventario:
          patrimonio.numeroInventario,
      descricao:
          patrimonio.descricao,
      local:
          patrimonio.local,
      responsavel:
          patrimonio.responsavel,
      dataRegistro:
          patrimonio.dataRegistro,
    );

    final index = lista.indexWhere(
      (item) => item.id == id,
    );

    lista[index] = atualizado;

    return atualizado;
  }


  @override
  Future<void> excluir(int id) async {

    lista.removeWhere(
      (item) => item.id == id,
    );
  }
}


// ========================================
// TESTES
// ========================================

void main() {

  late PatrimonioController controller;
  late FakePatrimonioService service;


  setUp(() {

    service = FakePatrimonioService();

    controller = PatrimonioController(
      service: service,
    );
  });


  // ======================================
  // TESTE LISTAR
  // ======================================

  test(
    'Deve listar os patrimônios',
    () async {

      await controller.listar();

      expect(
        controller.patrimonios.length,
        2,
      );

      expect(
        controller.patrimonios[0]
            .numeroInventario,
        'PAT001',
      );
    },
  );


  // ======================================
  // TESTE PESQUISA
  // ======================================

  test(
    'Deve pesquisar um patrimônio',
    () async {

      await controller.pesquisar(
        'Computador',
      );

      expect(
        controller.patrimonios.length,
        1,
      );

      expect(
        controller.patrimonios[0]
            .descricao,
        'Computador Dell',
      );
    },
  );


  // ======================================
  // TESTE BUSCAR POR ID
  // ======================================

  test(
    'Deve buscar patrimônio pelo ID',
    () async {

      final patrimonio =
          await controller.buscarPorId(1);

      expect(
        patrimonio,
        isNotNull,
      );

      expect(
        patrimonio!.id,
        1,
      );
    },
  );


  // ======================================
  // TESTE CADASTRAR
  // ======================================

  test(
    'Deve cadastrar um patrimônio',
    () async {

      final patrimonio = Patrimonio(

        id: 0,

        numeroInventario:
            'PAT003',

        descricao:
            'Notebook Lenovo',

        local:
            'Sala 3',

        responsavel:
            'Carlos',

        dataRegistro:
            DateTime(2026, 9, 8),
      );

      final resultado =
          await controller.cadastrar(
        patrimonio,
      );

      expect(
        resultado,
        true,
      );

      expect(
        controller.patrimonios.length,
        3,
      );
    },
  );


  // ======================================
  // TESTE EDITAR
  // ======================================

  test(
    'Deve editar um patrimônio',
    () async {

      final patrimonio = Patrimonio(

        id: 1,

        numeroInventario:
            'PAT001',

        descricao:
            'Computador Dell Atualizado',

        local:
            'Laboratório 2',

        responsavel:
            'Pedro',

        dataRegistro:
            DateTime(2026, 9, 8),
      );

      final resultado =
          await controller.editar(
        1,
        patrimonio,
      );

      expect(
        resultado,
        true,
      );

      expect(
        controller.patrimonios[0]
            .descricao,
        'Computador Dell Atualizado',
      );
    },
  );


  // ======================================
  // TESTE EXCLUIR
  // ======================================

  test(
    'Deve excluir um patrimônio',
    () async {

      await controller.listar();

      expect(
        controller.patrimonios.length,
        2,
      );

      final resultado =
          await controller.excluir(1);

      expect(
        resultado,
        true,
      );

      expect(
        controller.patrimonios.length,
        1,
      );

      expect(
        controller.patrimonios[0].id,
        2,
      );
    },
  );
}