import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/patrimonio_controller.dart';
import 'formulario_view.dart';

class DetalhesView extends StatelessWidget {
  final int id;

  DetalhesView({
    super.key,
    required this.id,
  });

  final PatrimonioController controller =
      Get.find<PatrimonioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do Patrimônio',
        ),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: controller.buscarPorId(id),

        builder: (context, snapshot) {

          // Carregando
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Erro
          if (snapshot.hasError ||
              !snapshot.hasData) {

            return const Center(
              child: Text(
                'Erro ao carregar patrimônio.',
              ),
            );
          }

          final patrimonio = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // ==========================
                // INVENTÁRIO
                // ==========================

                const Text(
                  'Número do inventário',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  patrimonio.numeroInventario,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================
                // DESCRIÇÃO
                // ==========================

                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  patrimonio.descricao,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================
                // LOCAL
                // ==========================

                const Text(
                  'Local',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  patrimonio.local,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================
                // RESPONSÁVEL
                // ==========================

                const Text(
                  'Responsável',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  patrimonio.responsavel,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================
                // DATA DE REGISTRO
                // ==========================

                const Text(
                  'Data de registro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _formatarData(
                    patrimonio.dataRegistro,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const Spacer(),

                // ==========================
                // BOTÕES
                // ==========================

                Row(
                  children: [

                    // EDITAR
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {

                          Get.to(
                            () => FormularioView(
                              patrimonio: patrimonio,
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.edit,
                        ),

                        label: const Text(
                          'Editar',
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // EXCLUIR
                    Expanded(
                      child: ElevatedButton.icon(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),

                        onPressed: () {
                          _confirmarExclusao();
                        },

                        icon: const Icon(
                          Icons.delete,
                        ),

                        label: const Text(
                          'Excluir',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================
  // CONFIRMAR EXCLUSÃO
  // ==========================

  void _confirmarExclusao() {

    Get.defaultDialog(
      title: 'Excluir patrimônio',

      middleText:
          'Tem certeza que deseja excluir este patrimônio?',

      textCancel: 'Cancelar',

      textConfirm: 'Excluir',

      confirmTextColor: Colors.white,

      onConfirm: () async {

        Get.back();

        final sucesso =
            await controller.excluir(id);

        if (sucesso) {
          Get.back();
        }
      },
    );
  }

  // ==========================
  // FORMATAR DATA
  // ==========================

  String _formatarData(DateTime data) {

    final dia =
        data.day.toString().padLeft(2, '0');

    final mes =
        data.month.toString().padLeft(2, '0');

    final ano =
        data.year.toString();

    return '$dia/$mes/$ano';
  }
}