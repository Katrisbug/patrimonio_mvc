import 'package:flutter_test/flutter_test.dart';

import 'package:mvc/model/patrimonio_model.dart';

void main() {

  group('Teste do Model Patrimonio', () {

    test(
      'Deve converter JSON para Patrimonio',
      () {

        final json = {
          'id': 1,
          'numero_inventario': 'PAT001',
          'descricao': 'Computador Dell',
          'local': 'Laboratório 1',
          'responsavel': 'João',
          'data_registro':
              '2026-09-08T10:00:00',
        };

        final patrimonio =
            Patrimonio.fromJson(json);

        expect(patrimonio.id, 1);

        expect(
          patrimonio.numeroInventario,
          'PAT001',
        );

        expect(
          patrimonio.descricao,
          'Computador Dell',
        );

        expect(
          patrimonio.local,
          'Laboratório 1',
        );

        expect(
          patrimonio.responsavel,
          'João',
        );

        expect(
          patrimonio.dataRegistro.year,
          2026,
        );
      },
    );


    test(
      'Deve converter Patrimonio para JSON',
      () {

        final patrimonio = Patrimonio(

          id: 1,

          numeroInventario: 'PAT001',

          descricao: 'Computador Dell',

          local: 'Laboratório 1',

          responsavel: 'João',

          dataRegistro:
              DateTime(2026, 9, 8),
        );

        final json =
            patrimonio.toJson();

        expect(
          json['numero_inventario'],
          'PAT001',
        );

        expect(
          json['descricao'],
          'Computador Dell',
        );

        expect(
          json['local'],
          'Laboratório 1',
        );

        expect(
          json['responsavel'],
          'João',
        );

        expect(
          json['data_registro'],
          isNotNull,
        );
      },
    );
  });
}