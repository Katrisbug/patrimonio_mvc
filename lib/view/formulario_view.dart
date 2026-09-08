import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/patrimonio_controller.dart';
import '../model/patrimonio_model.dart';

class FormularioView extends StatefulWidget {
  final Patrimonio? patrimonio;

  const FormularioView({
    super.key,
    this.patrimonio,
  });

  @override
  State<FormularioView> createState() =>
      _FormularioViewState();
}

class _FormularioViewState
    extends State<FormularioView> {

  final formKey = GlobalKey<FormState>();

  final numeroController =
      TextEditingController();

  final descricaoController =
      TextEditingController();

  final localController =
      TextEditingController();

  final responsavelController =
      TextEditingController();

  final PatrimonioController controller =
      Get.find<PatrimonioController>();

  bool get editando =>
      widget.patrimonio != null;

  @override
  void initState() {
    super.initState();

    // Se estiver editando,
    // coloca os dados nos campos
    if (widget.patrimonio != null) {

      numeroController.text =
          widget.patrimonio!.numeroInventario;

      descricaoController.text =
          widget.patrimonio!.descricao;

      localController.text =
          widget.patrimonio!.local;

      responsavelController.text =
          widget.patrimonio!.responsavel;
    }
  }

  @override
  void dispose() {

    numeroController.dispose();
    descricaoController.dispose();
    localController.dispose();
    responsavelController.dispose();

    super.dispose();
  }

  // ==========================
  // SALVAR
  // ==========================

  Future<void> salvar() async {

    // Verifica formulário
    if (!formKey.currentState!.validate()) {
      return;
    }

    final patrimonio = Patrimonio(

      // Se editando mantém o ID.
      // Se cadastrando começa com 0.
      id: widget.patrimonio?.id ?? 0,

      numeroInventario:
          numeroController.text.trim(),

      descricao:
          descricaoController.text.trim(),

      local:
          localController.text.trim(),

      responsavel:
          responsavelController.text.trim(),

      // Mantém a data na edição.
      // No cadastro usa a data atual.
      dataRegistro:
          widget.patrimonio?.dataRegistro ??
          DateTime.now(),
    );

    bool sucesso;

    // ==========================
    // EDITAR
    // ==========================

    if (editando) {

      sucesso = await controller.editar(
        widget.patrimonio!.id,
        patrimonio,
      );

    }

    // ==========================
    // CADASTRAR
    // ==========================

    else {

      sucesso = await controller.cadastrar(
        patrimonio,
      );
    }

    // Volta para tela anterior
    // se deu certo
    if (sucesso) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando
              ? 'Editar Patrimônio'
              : 'Cadastrar Patrimônio',
        ),
        centerTitle: true,
      ),

      body: Form(
        key: formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [

            // ==========================
            // NÚMERO DO INVENTÁRIO
            // ==========================

            TextFormField(
              controller:
                  numeroController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Número do inventário',
                hintText: 'Ex: PAT001',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.inventory),
              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return
                      'Informe o número do inventário';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ==========================
            // DESCRIÇÃO
            // ==========================

            TextFormField(
              controller:
                  descricaoController,

              maxLines: 3,

              decoration:
                  const InputDecoration(
                labelText: 'Descrição',
                hintText:
                    'Ex: Computador Dell',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.description),
              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return
                      'Informe a descrição';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ==========================
            // LOCAL
            // ==========================

            TextFormField(
              controller:
                  localController,

              decoration:
                  const InputDecoration(
                labelText: 'Local',
                hintText:
                    'Ex: Laboratório 1',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.location_on),
              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return
                      'Informe o local';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ==========================
            // RESPONSÁVEL
            // ==========================

            TextFormField(
              controller:
                  responsavelController,

              decoration:
                  const InputDecoration(
                labelText: 'Responsável',
                hintText:
                    'Ex: João da Silva',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.person),
              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return
                      'Informe o responsável';
                }

                return null;
              },
            ),

            const SizedBox(height: 25),

            // ==========================
            // BOTÃO SALVAR
            // ==========================

            Obx(
              () => SizedBox(
                height: 50,

                child: ElevatedButton(
                  onPressed:
                      controller.carregando.value
                          ? null
                          : salvar,

                  child:
                      controller.carregando.value

                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )

                          : Text(
                              editando
                                  ? 'Salvar alterações'
                                  : 'Cadastrar patrimônio',
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}