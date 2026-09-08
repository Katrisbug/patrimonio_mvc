import 'package:get/get.dart';
import '../service/patrimonio_service.dart';
import '../model/patrimonio_model.dart';

class PatrimonioController extends GetxController {

  //conecta o controller com o service
  final PatrimonioService service;

  PatrimonioController({
    PatrimonioService? service,}) : service = service ?? PatrimonioService();

  //lista de patrimonios
  var patrimonios = <Patrimonio>[].obs;

  //indica se esta carregando
  var carregando = false.obs;


  //1. Listar Patrimonios
  Future<void> listar() async {

    try {

      //começou a carregar
      carregando.value = true;

      //pede para o service buscar na api
      final resultado = await service.listarPatrimonios();

      //coloca os dados recebidos na lista
      patrimonios.assignAll(resultado);

    } catch (e) {

      //mostra erro
      Get.snackbar('Erro', 'Não foi possivel carregar os patrimonios',);

    } finally {
      //terminou de carregar
      carregando.value = false;
    }
  }


  //2. Pesquisar 
  Future<void> pesquisar(String termo) async {
    
    try {

      carregando.value = true;

      //se não digitou nada, mostra todos novamente
      if (termo.trim().isEmpty) {
        await listar();
        return;
      }

      //pesquisa atraves do service
      final resultado = await service.pesquisarPatrimonios(termo);

      //atualizar a lista
      patrimonios.assignAll(resultado);

    } catch (e) {
      
      Get.snackbar('Erro', 'Erro ao pesquisar patrimonio',);

    } finally {
      carregando.value = false;
    }
  }


  //3. Buscar por ID
  Future<Patrimonio?> buscarPorId(int id) async {
    try {

      carregando.value = true;

      //busca um patrimonio especifico
      final patrimonio = await service.buscarPorId(id);

      return patrimonio;

    } catch (e) {

      Get.snackbar('Erro', 'Erro ao buscar patrimonio',);
      return null;

    } finally {

      carregando.value = false;
    }
  }


  //4.Cadastrar
  Future<bool> cadastrar(Patrimonio patrimonio,) async {

    try {
      carregando.value = true;

      //envia para a API
      final novoPatrimonio = await service.cadastrar(patrimonio);

      //adiciona na lista
      patrimonios.add(novoPatrimonio);

      Get.snackbar('Sucesso', 'Patrimonio cadastrado!');
      return true;

    } catch (e) {

      Get.snackbar('Erro', 'Erro ao cadastrar patrimonio');
      return false;

    } finally {

      carregando.value = false;
    }
  }

  //5. Editar
  Future<bool> editar(int id, Patrimonio patrimonio) async {

    try{
      carregando.value = true;

      //envia a alteração para a API
      final patrimonioAtualizado = await service.editar(id, patrimonio);

      //procura o patrimonio na lista
      final index = patrimonios.indexWhere((item) =>item.id == id,);

      //se encontrou, atualiza
      if (index != -1) {
        patrimonioAtualizado;
      }

      Get.snackbar('Sucesso', 'Patrimonio atualizado!');
      return true;

    } catch (e) {

      Get.snackbar('Erro', 'Erro ao editar patrimonio');
      return false;

    } finally {

      carregando.value = false;
    }
  }


  //6. Excluir 
  Future<bool> excluir(int id) async {

    try {
      carregando.value = true;

      //manda o service excluir na API
      await service.excluir(id);

      //remove da lista
      patrimonios.removeWhere((item)=> item.id == id);

      Get.snackbar('Sucesso', 'Patrimonio excluido!');
      return true;

    } catch (e) {

      Get.snackbar('Erro', 'Erro ao excluir patrimonio');
      return false;

    } finally {

      carregando.value = false;
    }
  }

  //ininciar

  @override
  void onInit() {

    super.onInit();
    listar();
  }
}