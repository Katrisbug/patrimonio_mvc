import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/patrimonio_controller.dart';
import 'detalhes_view.dart';
import 'formulario_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final PatrimonioController controller =
      Get.put(PatrimonioController());

  final TextEditingController pesquisaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrimônios SENAI'),
        centerTitle: true,
      ),

      // Botão para cadastrar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => const FormularioView(),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [

          // ==========================
          // CAMPO DE PESQUISA
          // ==========================

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: pesquisaController,

              onChanged: (valor) {
                controller.pesquisar(valor);
              },

              decoration: InputDecoration(
                hintText: 'Pesquisar patrimônio',
                prefixIcon: const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    pesquisaController.clear();
                    controller.listar();
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // ==========================
          // LISTA
          // ==========================

          Expanded(
            child: Obx(() {

              // Carregando
              if (controller.carregando.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Lista vazia
              if (controller.patrimonios.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum patrimônio encontrado.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.listar,

                child: ListView.builder(
                  padding: const EdgeInsets.all(12),

                  itemCount:
                      controller.patrimonios.length,

                  itemBuilder: (context, index) {

                    final patrimonio =
                        controller.patrimonios[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),

                      child: ListTile(

                        // Ícone
                        leading: CircleAvatar(
                          child: Text(
                            patrimonio.id.toString(),
                          ),
                        ),

                        // Número do inventário
                        title: Text(
                          patrimonio.numeroInventario,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Informações
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            const SizedBox(height: 5),

                            Text(
                              patrimonio.descricao,
                            ),

                            const SizedBox(height: 3),

                            Text(
                              'Local: ${patrimonio.local}',
                            ),

                            Text(
                              'Responsável: '
                              '${patrimonio.responsavel}',
                            ),
                          ],
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),

                        // Abrir detalhes
                        onTap: () {
                          Get.to(
                            () => DetalhesView(
                              id: patrimonio.id,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}